import 'package:text_controller_manager/text_controller_manager.dart';

void main() {
  // Example usage of generateController
  generateController(
    'UserController',
    ['name', 'email', 'phone'],
    {'name': 'John Doe', 'email': 'john@example.com'},
  );

  print('Controller generated in lib/src/usercontroller.dart');
}
