[![GitHub license](https://img.shields.io/github/license/mintware-de/flutter_catalyst.svg)](https://github.com/mintware-de/flutter_catalyst/blob/master/LICENSE)
[![Travis](https://img.shields.io/travis/mintware-de/flutter_catalyst.svg)](https://travis-ci.org/mintware-de/flutter_catalyst)
[![Pub](https://img.shields.io/pub/v/flutter_catalyst.svg)](https://pub.dartlang.org/packages/flutter_catalyst)
[![Coverage Status](https://coveralls.io/repos/github/mintware-de/flutter_catalyst/badge.svg?branch=master)](https://coveralls.io/github/mintware-de/flutter_catalyst?branch=master)

# flutter_catalyst

[Catalyst](https://github.com/Devtronic/catalyst) is a dependency injection container for the dart language.

The flutter_catalyst project is a port of the catalyst project to provide dependency injection in Flutter projects.

## 📦 Installation
Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  flutter_catalyst: ^2.0.0
```

Then run `pub get`

## 💡 Usage

### Importing
```dart
import 'package:flutter_catalyst/flutter_catalyst.dart';
```

Check out the [examples](./example)

Supported functions:

| Function                                                                            | Description                                                          |
| :---------------------------------------------------------------------------------- | :------------------------------------------------------------------- |
| `get registeredTypes`                                                               | Return all registered types                                          |
| `register<T>(T service)`                                                            | Register a service for a specific interface                          |
| `registerInterface<TB, T extends TB>(T service)`                                    | Register a service                                                   |
| `registerWithDependencies<T>(serviceFactory, dependencies)`                         | Register a serviceFactory with dependencies                          |
| `registerInterfaceWithDependencies<TB, T extends TB>(serviceFactory, dependencies)` | Register a serviceFactory with dependencies for a specific interface |
| `unregister<T>()`                                                                   | Unregister a service                                                 |
| `get<T>()`                                                                          | Get a service by passing its type as <T>                             |
| `has<T>()`                                                                          | Check if a specific service is registered                            |
| `wire()`                                                                            | Wire the services with dependencies (`register*WithDependencies()`)  |
| `destroy()`                                                                         | Destroy the service container instance                               |
| `getFromToken<T>()`                                                                 | Get a service which was wrapped inside a InjectionToken              |

## 🔬 Testing

```bash
$ pub run test
```

## 🤝 Contribute
Feel free to fork and add pull-requests 🤓
