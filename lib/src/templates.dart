/// Templates for controller generation
library;

const String controllerTemplate = '''
import 'package:flutter/material.dart';

class {{className}} {
  {{fieldControllers}}

  {{disposeMethod}}
}
''';
