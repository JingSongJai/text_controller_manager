import 'package:flutter/material.dart';

class ProfileFormControllers {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController phone;

  ProfileFormControllers({Map<String, String>? initialValues})
      : 
        firstName = TextEditingController(text: initialValues?["firstName"] ?? 'John'),
        lastName = TextEditingController(text: initialValues?["lastName"] ?? ''),
        email = TextEditingController(text: initialValues?["email"] ?? 'john@example.com'),
        phone = TextEditingController(text: initialValues?["phone"] ?? '');

  void disposeAll() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
  }

  Map<String, String> toMap() => {
    'firstName': firstName.text,
    'lastName': lastName.text,
    'email': email.text,
    'phone': phone.text,
  };
}
