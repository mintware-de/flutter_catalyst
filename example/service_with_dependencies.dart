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

  // Register a service which requires another dependencies
  // The first parameter is a factory which is used to create the service
  // The factory retrieves the instances of the required dependencies
  //
  // The second parameter is a list of the types of the required dependencies
  container.registerWithDependencies<StackPrinter>((List<dynamic> deps) {
    var stackAsAService = deps[0];
    return StackPrinter(stackAsAService);
  }, [StackAsAService]);

  // Register the StackAsAService in the container
  container.register(StackAsAService());

  print(container.has<StackPrinter>()); // false

  container.wire(); // Wire the services

  print(container.has<StackPrinter>()); // true

  // Get the StackAsAService from the container
  var stack = container.get<StackAsAService>();

  stack.add("Hello");
  stack.add("World");

  var printer = container.get<StackPrinter>();
  printer.printStack(); // [Hello, World]
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

class StackPrinter {
  final StackAsAService stack;

  StackPrinter(this.stack);

  printStack() {
    print(stack.entries);
  }
}
