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

  // Register the StackAsAService in the container
  container.register(StackAsAService());

  // Get the registered service from the container
  var stack = container.get<StackAsAService>();

  // Modify the stack
  print(stack.length); // Outputs 0

  stack.add("Hello");
  stack.add("World");

  print(stack.length); // Outputs 2

  print(stack.entries); // Outputs [Hello, World]

  // Retrieve the  same service again from the container
  var anotherStack = container.get<StackAsAService>();

  print(anotherStack.length); // Outputs 2

  print(anotherStack.entries); // Outputs [Hello, World]

  // Modify it...
  anotherStack.remove('World');

  // And the first variable is also modified
  print(stack.length); // Outputs 2

  print(stack.entries); // Outputs [Hello]
}

class StackAsAService {
  List<String> _entries = <String>[];

  void add(String entry) {
    _entries.add(entry);
  }

  void remove(String entry) {
    _entries.removeWhere((e) => e == entry);
  }

  List<String> get entries => _entries;

  int get length => _entries.length;
}
