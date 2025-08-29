import 'dart:io';
import 'package:logging/logging.dart';

void generateController(
  String className,
  List<String> fields,
  Map<String, String> defaultValues, { // pre-defined defaults
  String outputDir = 'lib/src', // optional output directory
}) {
  // Setup logger
  final log = Logger('ControllerGenerator');
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final buffer = StringBuffer();
  buffer.writeln('import \'package:flutter/material.dart\';\n');
  buffer.writeln('class $className {');

  // Fields
  for (var field in fields) {
    buffer.writeln('  final TextEditingController $field;');
  }

  // Constructor with initialValues map
  buffer.writeln('\n  $className({Map<String, String>? initialValues})');
  buffer.writeln('      : ');

  final initializations = fields
      .map((field) {
        final defaultValue = defaultValues[field] != null
            ? "'${defaultValues[field]}'"
            : "''";
        return '$field = TextEditingController(text: initialValues?["$field"] ?? $defaultValue)';
      })
      .join(',\n        ');

  buffer.writeln('        $initializations;');

  // disposeAll method
  buffer.writeln('\n  void disposeAll() {');
  for (var field in fields) buffer.writeln('    $field.dispose();');
  buffer.writeln('  }');

  // toMap method
  buffer.writeln('\n  Map<String, String> toMap() => {');
  for (var field in fields) buffer.writeln('    \'$field\': $field.text,');
  buffer.writeln('  };');

  buffer.writeln('}');

  // Ensure output directory exists
  Directory(outputDir).createSync(recursive: true);
  final fileName = '$outputDir/${className.toLowerCase()}.dart';
  File(fileName).writeAsStringSync(buffer.toString());

  log.info('Generated $className at $fileName successfully!');
}
