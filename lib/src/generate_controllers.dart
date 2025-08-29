import 'dart:io';
import 'package:logging/logging.dart';
import 'dart:convert';

/// Generates a Flutter controller class with [TextEditingController] fields.
///
/// [className] is the name of the class to generate.
/// [fields] is a list of field names to include as TextEditingControllers.
/// [defaultValues] provides optional default values for the fields.
///
/// The generated class includes:
/// - a constructor that accepts initial values,
/// - a `disposeAll()` method to dispose controllers,
/// - a `toMap()` method to get the values as a map.

void generateController(
  String className,
  List<String> fields,
  Map<String, String> defaultValues, {
  String outputDir = 'lib/controllers',
}) {
  final log = Logger('ControllerGenerator');
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final buffer = StringBuffer();
  buffer.writeln('import \'dart:convert\';\n');
  buffer.writeln('import \'package:flutter/material.dart\';\n');
  buffer.writeln('// Generated controller class for $className');
  buffer.writeln('class $className {');

  // Fields
  for (var field in fields) {
    buffer.writeln('  final TextEditingController $field;');
  }

  // Constructor
  buffer.writeln('\n  $className({Map<String, String>? initialValues})');
  buffer.writeln('      : ');

  final initializations = fields
      .map((field) {
        final defaultValue = defaultValues[field] != null
            ? jsonEncode(defaultValues[field])
            : "''";
        return '$field = TextEditingController(text: initialValues?["$field"] ?? $defaultValue)';
      })
      .join(',\n        ');

  buffer.writeln('        $initializations;');

  // Dispose
  buffer.writeln('\n  /// Dispose all controllers');
  buffer.writeln('  void disposeAll() {');
  for (var field in fields) {
    buffer.writeln('    $field.dispose();');
  }
  buffer.writeln('  }');

  // toMap
  buffer.writeln('\n  /// Convert all controller values to Map');
  buffer.writeln('  Map<String, String> toMap() => {');
  for (var field in fields) {
    buffer.writeln('    "$field": $field.text,');
  }
  buffer.writeln('  };');

  // fromMap
  buffer.writeln('\n  /// Create controller from Map');
  buffer.writeln('  factory $className.fromMap(Map<String, String> map) {');
  buffer.writeln('    return $className(initialValues: map);');
  buffer.writeln('  }');

  // clearAll
  buffer.writeln('\n  /// Clear all fields');
  buffer.writeln('  void clearAll() {');
  for (var field in fields) {
    buffer.writeln('    $field.clear();');
  }
  buffer.writeln('  }');

  // setValues
  buffer.writeln('\n  /// Set multiple fields at once');
  buffer.writeln('  void setValues(Map<String, String> values) {');
  for (var field in fields) {
    buffer.writeln(
      '    if (values.containsKey("$field")) { $field.text = values["$field"]!; }',
    );
  }
  buffer.writeln('  }');

  // updateField
  buffer.writeln('\n  /// Update single field safely');
  buffer.writeln('  void updateField(String fieldName, String value) {');
  buffer.writeln('    switch(fieldName) {');
  for (var field in fields) {
    buffer.writeln('      case "$field": $field.text = value; break;');
  }
  buffer.writeln('      default: break;');
  buffer.writeln('    }');
  buffer.writeln('  }');

  // isEmpty
  buffer.writeln('\n  /// Check if all fields are empty');
  buffer.writeln('  bool isEmpty() => ');
  buffer.writeln('${fields.map((f) => '$f.text.isEmpty').join(' && ')};');

  // anyEmpty
  buffer.writeln('\n  /// Check if any field is empty');
  buffer.writeln('  bool anyEmpty() => ');
  buffer.writeln('${fields.map((f) => '$f.text.isEmpty').join(' || ')};');

  // contains
  buffer.writeln('\n  /// Check if any field contains the given value');
  buffer.writeln('  bool contains(String value) => ');
  buffer.writeln(
    '${fields.map((f) => '$f.text.contains(value)').join(' || ')};',
  );

  // toJson
  buffer.writeln('\n  /// Convert to JSON string');
  buffer.writeln('  String toJson() => jsonEncode(toMap());');

  // fromJson
  buffer.writeln('\n  /// Initialize from JSON string');
  buffer.writeln('  factory $className.fromJson(String json) {');
  buffer.writeln(
    '    return $className.fromMap(Map<String, String>.from(jsonDecode(json)));',
  );
  buffer.writeln('  }');

  buffer.writeln('}');

  Directory(outputDir).createSync(recursive: true);
  final fileName = '$outputDir/${className.toLowerCase()}.dart';
  File(fileName).writeAsStringSync(buffer.toString());

  log.info('Generated $className at $fileName successfully!');
}
