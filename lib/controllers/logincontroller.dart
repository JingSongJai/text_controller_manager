import 'dart:convert';

import 'package:flutter/material.dart';

// Generated controller class for LoginController
class LoginController {
  final TextEditingController email;
  final TextEditingController password;

  LoginController({Map<String, String>? initialValues})
      : 
        email = TextEditingController(text: initialValues?["email"] ?? ''),
        password = TextEditingController(text: initialValues?["password"] ?? '');

  /// Dispose all controllers
  void disposeAll() {
    email.dispose();
    password.dispose();
  }

  /// Convert all controller values to Map
  Map<String, String> toMap() => {
    "email": email.text,
    "password": password.text,
  };

  /// Create controller from Map
  factory LoginController.fromMap(Map<String, String> map) {
    return LoginController(initialValues: map);
  }

  /// Clear all fields
  void clearAll() {
    email.clear();
    password.clear();
  }

  /// Set multiple fields at once
  void setValues(Map<String, String> values) {
    if (values.containsKey("email")) { email.text = values["email"]!; }
    if (values.containsKey("password")) { password.text = values["password"]!; }
  }

  /// Update single field safely
  void updateField(String fieldName, String value) {
    switch(fieldName) {
      case "email": email.text = value; break;
      case "password": password.text = value; break;
      default: break;
    }
  }

  /// Check if all fields are empty
  bool isEmpty() => 
email.text.isEmpty && password.text.isEmpty;

  /// Check if any field is empty
  bool anyEmpty() => 
email.text.isEmpty || password.text.isEmpty;

  /// Check if any field contains the given value
  bool contains(String value) => 
email.text.contains(value) || password.text.contains(value);

  /// Convert to JSON string
  String toJson() => jsonEncode(toMap());

  /// Initialize from JSON string
  factory LoginController.fromJson(String json) {
    return LoginController.fromMap(Map<String, String>.from(jsonDecode(json)));
  }
}
