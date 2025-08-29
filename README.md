# `text_controller_manager`

[![pub package](https://img.shields.io/pub/v/text_controller_manager)](https://pub.dev/packages/text_controller_manager)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

# Many TextField would bring many controllers as well, right? that would be annoy to create all of that controllers everytime, right?

A Dart CLI tool for **generating Flutter TextEditingController classes** from YAML configuration.
Perfect for quickly scaffolding form controllers with `disposeAll()` and `toMap()` methods.

---

## **Features**

- Generate Flutter controller classes automatically.
- Supports default values for each field.
- Includes `disposeAll()` for memory safety.
- Includes `toMap()` for easy form submission.
- CLI usage with custom YAML config and output directory.

---

## **Installation**

Add the package to your project:

```yaml
dev_dependencies:
  text_controller_manager: ^0.0.2
```

Then run:

```bash
dart pub get
```

---

## **Usage (CLI)**

> Make sure to create `controllers.ymal` in root project

Generate controllers from a YAML file:

```bash
dart run text_controller_manager:generate
```

### **Options**

```text
-c, --config   Path to YAML configuration file (default: controllers.yaml)
-o, --output   Output directory for generated controllers (default: lib/controllers/)
-h, --help     Show this help message
```

### **Examples**

1. **Default usage** (uses `controllers.yaml` and outputs to `lib/controllers/`):

```bash
dart run text_controller_manager:generate
```

2. **Custom YAML file**:

```bash
dart run text_controller_manager:generate -c my_controllers.yaml
```

3. **Custom output directory**:

```bash
dart run text_controller_manager:generate -c lib/custom_controllers/
```

4. **Custom config and output**:

```bash
dart run text_controller_manager:generate -c my_controllers.yaml -o lib/custom_controllers/
```

---

## **YAML Configuration Example**

```yaml
controllers:
  - className: UserController
    fields:
      - name
      - email
      - phone
    initialValues:
      name: "John Doe"
      email: "john@example.com"
```

- `className` — the name of the Dart controller class.
- `fields` — list of `TextEditingController` fields.
- `initialValues` — optional default values for each field.

---

## **Generated Class Example**

For the above YAML, the generated class:

```dart
class UserController {
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;

  UserController({Map<String, String>? initialValues})
      : name = TextEditingController(text: initialValues?['name'] ?? 'John Doe'),
        email = TextEditingController(text: initialValues?['email'] ?? ''),
        phone = TextEditingController(text: initialValues?['phone'] ?? '');

  void disposeAll() {
    name.dispose();
    email.dispose();
    phone.dispose();
  }

  Map<String, String> toMap() => {
        'name': name.text,
        'email': email.text,
        'phone': phone.text,
      };
}
```

---

## **Notes**

- Make sure the output directory exists or let the tool create it automatically.
- Always call `disposeAll()` for cleanup in Flutter widgets.
- Supports multiple controllers in a single YAML file.

---

## **Contributing**

1. Fork the repo
2. Create a branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add feature'`
4. Push: `git push origin feature/my-feature`
5. Open a Pull Request

---

## **License**

This project is licensed under the [MIT License](LICENSE).

---
