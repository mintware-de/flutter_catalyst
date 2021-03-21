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
  test(
    'The ServiceFactory should return the correct value with e correct type',
    () {
      ServiceFactory<int> sf = (deps) {
        expect(deps, isEmpty);
        return 1;
      };

      var actual = sf([]);
      expect(actual, TypeMatcher<int>());
      expect(actual, equals(1));
    },
  );

  test('The arguments should be passed correctly to the ServiceFactory.', () {
    ServiceFactory<int> sf = (deps) {
      expect(deps[0], TypeMatcher<String>());
      expect(deps[1], TypeMatcher<String>());
      return int.parse(deps[0]) + int.parse(deps[1]);
    };

    var actual = sf(["2", "3"]);

    expect(actual, TypeMatcher<int>());
    expect(actual, equals(5));
  });

  test('The dependency instances should be same.', () {
    var testInstanceA = _TestInstanceA();
    var testInstanceB = _TestInstanceB();

    ServiceFactory<List> sf = (deps) {
      expect(deps[0], TypeMatcher<_TestInstanceA>());
      expect(deps[1], TypeMatcher<_TestInstanceB>());
      expect(deps[0], same(testInstanceA));
      expect(deps[1], same(testInstanceB));
      return deps;
    };

    var actual = sf([testInstanceA, testInstanceB]);

    expect(actual, TypeMatcher<List>());
    expect(actual[0], same(testInstanceA));
    expect(actual[1], same(testInstanceB));
  });
}

class _TestInstanceA {}

class _TestInstanceB {}
