/*
 * This file is part of the flutter_catalyst package.
 *
 * Copyright 2020 - present by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 */

import 'package:flutter_catalyst/flutter_catalyst.dart';
import 'package:test/test.dart';

void main() {
  tearDown(() {
    DependencyContainer().destroy();
  });

  test(
    'The DependencyContainer should implement the DependencyContainerInterface',
    () {
      DependencyContainerInterface dc = DependencyContainer();

      expect(dc, TypeMatcher<DependencyContainerInterface>());
    },
  );

  test(
    'The DependencyContainer should follow the singleton pattern',
    () {
      DependencyContainerInterface dc1 = DependencyContainer();
      DependencyContainerInterface dc2 = DependencyContainer();
      expect(dc1, same(dc2));
    },
  );

  test(
    'The DependencyContainer should contain itself',
    () {
      DependencyContainerInterface dc = DependencyContainer();

      expect(dc.get<DependencyContainer>(), same(dc));
      expect(dc.get<DependencyContainerInterface>(), same(dc));
    },
  );

  test(
    'The DependencyContainer should return all registered types',
    () {
      DependencyContainerInterface dc = DependencyContainer();

      var registeredTypes = dc.registeredTypes;
      expect(registeredTypes, hasLength(2));

      expect(registeredTypes, contains(DependencyContainer));
      expect(registeredTypes, contains(DependencyContainerInterface));
    },
  );

  test('The DependencyContainer should register a concrete service', () {
    DependencyContainerInterface dc = DependencyContainer();
    expect(dc.registeredTypes, hasLength(2));

    var svc = _ExampleService();

    dc.register(svc);
    expect(dc.has<_ExampleService>(), isTrue);
    expect(dc.get<_ExampleService>(), same(svc));
  });

  test('The DependencyContainer should not register a dependency twice', () {
    DependencyContainerInterface dc = DependencyContainer();
    expect(dc.registeredTypes, hasLength(2));

    dc.register(_ExampleService());

    expect(
      () => dc.register(_ExampleService()),
      throwsA((e) =>
          e.message ==
          'A service for the type _ExampleService is already registered'),
    );
  });

  test(
      'The DependencyContainer should register a interface with a implementation',
      () {
    DependencyContainerInterface dc = DependencyContainer();
    expect(dc.registeredTypes, hasLength(2));

    var svc = _ExampleService();

    dc.registerInterface<_ExampleServiceInterface, _ExampleService>(svc);
    expect(dc.has<_ExampleServiceInterface>(), isTrue);
    expect(dc.get<_ExampleServiceInterface>(), same(svc));

    expect(
      () => dc.get<_ExampleService>(),
      throwsA((e) =>
          e.message ==
          'A service for the type _ExampleService is not registered'),
    );
  });

  test('The dependency container should return a registered service', () {
    DependencyContainerInterface dc = DependencyContainer();
    expect(dc.registeredTypes, hasLength(2));

    var svc = _ExampleService();
    dc.register(svc);

    expect(dc.get<_ExampleService>(), same(svc));
  });

  test(
      'The DependencyContainer should throw an exception for not registered services',
      () {
    DependencyContainerInterface dc = DependencyContainer();
    expect(dc.registeredTypes, hasLength(2));

    expect(
      () => dc.get<_ExampleService>(),
      throwsA((e) =>
          e.message ==
          'A service for the type _ExampleService is not registered'),
    );
  });

  test(
      'The has<T> method should return if a service is registered for the Type',
      () {
    DependencyContainerInterface dc = DependencyContainer();
    expect(dc.registeredTypes, hasLength(2));

    expect(dc.has<_ExampleService>(), isFalse);
    dc.register(_ExampleService());
    expect(dc.has<_ExampleService>(), isTrue);
  });

  test(
    'The DependencyContainer should wire a service with dependencies',
    () {
      DependencyContainerInterface dc = DependencyContainer();
      expect(dc.registeredTypes, hasLength(2));

      dc.registerWithDependencies((dependencies) {
        expect(dependencies[0], TypeMatcher<_DependencyService>());

        return _ExampleService(dependency: dependencies[0]);
      }, [_DependencyService]);

      expect(dc.has<_ExampleService>(), isFalse);
      expect(dc.has<_DependencyService>(), isFalse);

      var dependencyService = _DependencyService();
      dc.register(dependencyService);

      expect(dc.has<_ExampleService>(), isFalse);
      expect(dc.has<_DependencyService>(), isTrue);

      dc.wire();

      expect(dc.has<_ExampleService>(), isTrue);
      expect(dc.get<_ExampleService>().dependency, same(dependencyService));
    },
  );

  test(
    'The DependencyContainer should wire a interface with dependencies',
    () {
      DependencyContainerInterface dc = DependencyContainer();
      expect(dc.registeredTypes, hasLength(2));

      dc.registerInterfaceWithDependencies<_ExampleServiceInterface,
          _ExampleService>(
        (dependencies) {
          expect(dependencies[0], TypeMatcher<_DependencyService>());

          return _ExampleService(dependency: dependencies[0]);
        },
        [_DependencyService],
      );

      expect(dc.has<_ExampleService>(), isFalse);
      expect(dc.has<_ExampleServiceInterface>(), isFalse);
      expect(dc.has<_DependencyService>(), isFalse);

      dc.register(_DependencyService());

      expect(dc.has<_ExampleServiceInterface>(), isFalse);
      expect(dc.has<_DependencyService>(), isTrue);

      dc.wire();

      expect(dc.has<_ExampleService>(), isFalse);
      expect(dc.has<_ExampleServiceInterface>(), isTrue);
    },
  );

  test(
    'The DependencyContainer should not wire when dependencies are missing',
    () {
      DependencyContainerInterface dc = DependencyContainer();
      expect(dc.registeredTypes, hasLength(2));

      dc.registerWithDependencies<_ExampleService>(
        (deps) => _ExampleService(),
        [_DependencyService],
      );

      expect(dc.has<_ExampleService>(), isFalse);
      expect(dc.has<_DependencyService>(), isFalse);

      expect(
        () => dc.wire(),
        throwsA((e) =>
            e.message ==
            '''
Not all services could be autowired!

_ExampleService requires the following dependencies which aren't registered:
[ _DependencyService ]
  ^-----------------  

'''),
      );
    },
  );

  test(
    'The DependencyContainer should unregister registered services',
    () {
      DependencyContainerInterface dc = DependencyContainer();
      expect(dc.registeredTypes, hasLength(2));

      dc.unregister<DependencyContainer>();
      dc.unregister<DependencyContainerInterface>();
      expect(dc.registeredTypes, hasLength(0));
    },
  );

  test(
    'The DependencyContainer should not unregister unregistered services',
    () {
      DependencyContainerInterface dc = DependencyContainer();
      expect(dc.registeredTypes, hasLength(2));

      expect(
        () => dc.unregister<_ExampleService>(),
        throwsA((e) =>
            e.message ==
            'A service for the type _ExampleService is not registered'),
      );
    },
  );

  test('Injection tokens should provide the service instance', () {
    DependencyContainerInterface dc = DependencyContainer();

    dc.registerWithDependencies((deps) {
      return _ExampleService(dependency: deps[0]);
    }, [MyToken]);

    dc.register(MyToken());

    dc.wire();
  });
  test('getFromToken should return the instance of a InjectionToken', () {
    DependencyContainerInterface dc = DependencyContainer();
    var myToken = MyToken();
    dc.register(myToken);

    var svc = dc.getFromToken<_DependencyService>();
    expect(svc, TypeMatcher<_DependencyService>());
    expect(svc, same(myToken.value));
  });
}

abstract class _ExampleServiceInterface {}

class _ExampleService implements _ExampleServiceInterface {
  final _DependencyService dependency;

  _ExampleService({this.dependency});
}

class _DependencyService {}

class MyToken extends InjectionToken<_DependencyService> {
  MyToken() : super(_DependencyService());
}
