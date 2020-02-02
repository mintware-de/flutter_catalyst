/*
 * This file is part of the flutter_catalyst package.
 *
 * Copyright 2020 - present by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 */

import 'dependency_container_test.dart' as DependencyContainerTest;
import 'injection_token_test.dart' as InjectionTokenTest;
import 'service_factory_test.dart' as ServiceFactoryTest;

main() {
  DependencyContainerTest.main();
  InjectionTokenTest.main();
  ServiceFactoryTest.main();
}