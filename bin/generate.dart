#!/usr/bin/env dart

import 'dart:io';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;
import '../tool/generate_controllers.dart';

void main(List<String> arguments) {
  // Setup logger
  final log = Logger('Generator');
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Default config
  String configPath = 'controllers.yaml';
  String outputDir = 'lib/src/';

  // Parse arguments
  // Parse arguments
  for (int i = 0; i < arguments.length; i++) {
    final arg = arguments[i];
    if (arg == '-c' || arg == '--config') {
      if (i + 1 < arguments.length) {
        configPath = arguments[i + 1];
        i++; // Skip next argument as it's used
      } else {
        log.severe('❌ Missing value for --config');
        exit(1);
      }
    } else if (arg == '-o' || arg == '--output') {
      if (i + 1 < arguments.length) {
        outputDir = arguments[i + 1];
        i++; // Skip next argument as it's used
      } else {
        log.severe('❌ Missing value for --output');
        exit(1);
      }
    } else if (arg == '-h' || arg == '--help') {
      log.info('''
              Usage: dart run tool:generate [options]

              Options:
                -c, --config   Path to YAML configuration file (default: controllers.yaml)
                -o, --output   Output directory for generated controllers (default: lib/src/)
                -h, --help     Show this help message
              ''');
      exit(0);
    }
  }

  final yamlFile = File(configPath);
  if (!yamlFile.existsSync()) {
    log.severe('❌ YAML file not found: $configPath');
    exit(1);
  }

  final yamlContent = yamlFile.readAsStringSync();
  final yamlMap = loadYaml(yamlContent);

  final controllers = yamlMap['controllers'] as YamlList;

  // Track YAML class names for deletion
  final yamlClassNames = <String>[];

  for (var controller in controllers) {
    final className = controller['className'].toString();
    yamlClassNames.add(className.toLowerCase());

    final fields = (controller['fields'] as YamlList)
        .map((e) => e.toString())
        .toList();
    final initialValues = <String, String>{};

    if (controller['initialValues'] != null) {
      (controller['initialValues'] as YamlMap).forEach((key, value) {
        initialValues[key.toString()] = value.toString();
      });
    }

    generateController(className, fields, initialValues, outputDir: outputDir);
  }

  // Delete obsolete controllers
  final outputDirectory = Directory(outputDir);
  if (outputDirectory.existsSync()) {
    final existingFiles = outputDirectory
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

    for (var file in existingFiles) {
      final fileName = p.basenameWithoutExtension(file.path).toLowerCase();
      if (!yamlClassNames.contains(fileName)) {
        try {
          file.deleteSync();
          log.info('🗑 Deleted obsolete controller: $yamlClassNames');
        } catch (e) {
          log.warning('Failed to delete ${file.path}: $e');
        }
      }
    }
  }

  log.info('✅ All controllers synchronized successfully!');
}
