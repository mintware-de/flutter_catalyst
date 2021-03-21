/*
 * This file is part of the flutter_catalyst package.
 *
 * Copyright 2020 - present by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 */

part of 'flutter_catalyst.dart';

class DependencyContainer implements DependencyContainerInterface {
  final Map<Type, _ServiceWithDependencies> _factories = {};
  final Map<Type, dynamic> _registrations = {};

  ///region Singleton
  static DependencyContainer _instance = DependencyContainer._ctor();

  DependencyContainer._ctor() {
    registerInterface<DependencyContainerInterface, DependencyContainer>(this);
    register(this);
  }

  factory DependencyContainer() {
    return _instance;
  }

  ///endregion

  @override
  List<Type> get registeredTypes {
    return _registrations.keys.toList();
  }

  @override
  void register<T>(T service) => _register(T, service);

  void _register(Type t, dynamic service) => _registerInterface(t, t, service);

  @override
  void registerInterface<TB, T extends TB>(T service) {
    _registerInterface(TB, T, service);
  }

  void _registerInterface(Type tb, Type t, dynamic service) {
    if (_registrations.containsKey(tb)) {
      throw Exception('A service for the type $t is already registered');
    }

    _registrations[tb] = service;
  }

  @override
  T get<T>() {
    return _get(T);
  }

  dynamic _get(Type t) {
    if (!_has(t)) {
      throw Exception('A service for the type $t is not registered');
    }
    return _registrations[t];
  }

  @override
  bool has<T>() {
    return _has(T);
  }

  bool _has(Type t) {
    return _registrations.containsKey(t);
  }

  @override
  T getFromToken<T>() {
    return _registrations.values
        .whereType<InjectionToken?>()
        .firstWhere((t) => t?.type == T, orElse: () => null)
        ?.value;
  }

  @override
  void registerWithDependencies<T>(
    ServiceFactory<T> serviceFactory,
    List<Type> dependencies,
  ) {
    _factories[T] = _ServiceWithDependencies(serviceFactory, dependencies);
  }

  @override
  void registerInterfaceWithDependencies<TB, T extends TB>(
    ServiceFactory<T> serviceFactory,
    List<Type> dependencies,
  ) {
    _factories[TB] = _ServiceWithDependencies(serviceFactory, dependencies);
  }

  @override
  void wire() {
    int numberOfServices;
    do {
      numberOfServices = _factories.length;

      // ignore: omit_local_variable_types
      List<Type> factoriesToRemove = [];

      _factories.forEach((Type t, _ServiceWithDependencies s) {
        var allDepsAvailable = s.dependencies.where((t) => !_has(t)).isEmpty;
        if (allDepsAvailable) {
          var dependencies = s.dependencies.map((t) {
            var dep = _get(t);
            return dep is InjectionToken ? dep.value : dep;
          }).toList();
          var service = s.serviceFactory(dependencies);
          _register(t, service);
          factoriesToRemove.add(t);
        }
      });
      factoriesToRemove.forEach((Type t) => _factories.remove(t));
    } while (numberOfServices > _factories.length);

    if (_factories.isNotEmpty) {
      throw _buildAutoWireException();
    }
  }

  Exception _buildAutoWireException() {
    var exceptionMessage = 'Not all services could be autowired!\n\n';

    _factories.forEach((Type t, _ServiceWithDependencies s) {
      exceptionMessage +=
          '$t requires the following dependencies which aren\'t registered:\n';
      var dependencyString = '[ ${s.dependencies.join(', ')} ]';
      var missingString = '  ';
      s.dependencies.forEach((Type type) {
        var typeNameLength = type.toString().length + 2;
        if (!_has(type)) {
          missingString += '^' + ('-' * (typeNameLength - 3));
          typeNameLength -= 1 + (typeNameLength - 3);
        }
        missingString += (' ' * typeNameLength);
      });

      exceptionMessage += '$dependencyString\n$missingString\n\n';
    });

    return Exception(exceptionMessage);
  }

  @override
  void destroy() {
    _registrations.clear();
    _factories.clear();

    _instance = DependencyContainer._ctor();
  }

  @override
  void unregister<T>() {
    if (!has<T>()) {
      throw Exception(
        'A service for the type _ExampleService is not registered',
      );
    }
    _registrations.remove(T);
  }
}

class _ServiceWithDependencies<T> {
  final ServiceFactory<T> serviceFactory;
  final List<Type> dependencies;

  _ServiceWithDependencies(
    this.serviceFactory,
    this.dependencies,
  );
}
