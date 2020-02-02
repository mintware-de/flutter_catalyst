/*
 * This file is part of the flutter_catalyst package.
 *
 * Copyright 2020 - present by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 */

import 'package:flutter_catalyst/flutter_catalyst.dart';

main() {
  var container = DependencyContainer();

  // No problem:
  // container.register(GenericStack<String>());
  // var stringStack = container.get<GenericStack<String>>();

  // The problem
  // container.register(GenericStack<String>());
  // container.registerWithDependencies((deps) {
  //   return StackPrinter(deps[0]);
  // }, [GenericStack]); // <-- can't pass the type here

  // Solution
  var injectionToken = StringStackToken();
  container.register(injectionToken);

  container.registerWithDependencies<StackPrinter>((deps) {
    // deps[0] is NOT the Token but the GenericStack<String> instance
    return StackPrinter(deps[0]);
  }, [StringStackToken]);

  container.wire();

  var stack = container.getFromToken<GenericStack<String>>();
  stack.add('Hello');
  stack.add('World');

  var stackPrinter = container.get<StackPrinter>();
  stackPrinter.printStack(); // [Hello, World]
}

class GenericStack<T> {
  List<T> _entries = [];

  void add(T entry) {
    _entries.add(entry);
  }

  void remove(T entry) {
    _entries.removeWhere((e) => e == entry);
  }

  List<T> get entries => _entries;

  int get length => _entries.length;
}

class StringStackPrinter {
  final GenericStack<String> stack;

  StringStackPrinter(this.stack);
}

class StringStackToken extends InjectionToken<GenericStack<String>> {
  StringStackToken() : super(GenericStack<String>());
}

class StackPrinter {
  final GenericStack stack;

  StackPrinter(this.stack);

  printStack() {
    print(stack.entries);
  }
}
