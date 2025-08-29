import 'package:flutter/material.dart';
import 'package:text_controller_manager/controllers/logincontroller.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(home: const LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = LoginController();

  @override
  void dispose() {
    loginController.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: loginController.email),
          TextField(controller: loginController.password),
          ElevatedButton(
            onPressed: () {
              print(loginController.toJson());
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
