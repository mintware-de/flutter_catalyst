/*
 * This file is part of the flutter_catalyst package.
 *
 * Copyright 2020 - present by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 */

part of 'flutter_catalyst.dart';

class InjectionToken<T> {
  final T value;

  InjectionToken(this.value);

  Type get type => T;
}
