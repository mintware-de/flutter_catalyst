/*
 * This file is part of the flutter_catalyst package.
 *
 * Copyright 2020 - present by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 */

part of 'flutter_catalyst.dart';

abstract class DependencyContainerInterface {
  /// Return all registered types
  List<Type> get registeredTypes;

  /// Register a [service]
  void register<T>(T service);

  /// Register a [serviceFactory] with [dependencies]
  ///
  /// The service factory will be called when [wire] method is called.
  void registerWithDependencies<T>(
    ServiceFactory<T> serviceFactory,
    List<Type> dependencies,
  );

  /// Register a [service] for a specific interface
  void registerInterface<TB, T extends TB>(T service);

  /// Register a [serviceFactory] with [dependencies] for a specific type.
  ///
  /// The service factory will be called when [wire] method is called.
  void registerInterfaceWithDependencies<TB, T extends TB>(
    ServiceFactory<T> serviceFactory,
    List<Type> dependencies,
  );

  /// Unregister a service type
  void unregister<T>();

  /// Get a dependency by passing its type as [T]
  T get<T>();

  /// Get a dependency which was passed inside a injection token
  T getFromToken<T>();

  /// Check if a specific dependency is registered
  bool has<T>();

  // Auto wire services
  void wire();

  // Destroy the service container instance.
  void destroy();
}
