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
  test('The InjectionToken should hold the initial passed value', () {
    var token = InjectionToken<int>(0);

    expect(token, TypeMatcher<InjectionToken>());
    expect(token.value, equals(0));
  });

  test('The instance passed in the InjectionToken should be same.', () {
    var testInstanceA = _TestInstanceA();
    var token = InjectionToken<_TestInstanceA>(testInstanceA);

    expect(token, TypeMatcher<InjectionToken>());
    expect(token.value, same(testInstanceA));
    expect(token.type, equals(_TestInstanceA));
  });
}

class _TestInstanceA {}
