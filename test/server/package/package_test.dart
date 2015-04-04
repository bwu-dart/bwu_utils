@TestOn('vm')
library bwu_utils.test.server.package;

import 'package:bwu_utils/testing_server.dart';

import 'package:path/path.dart' as path;

void main() {
  initLogging();
  group('package_test', () {
    test('package', () {
      // set up
      // exercise
      // verification
      expect(path.basename(packageRoot().path), equals('bwu_utils'));
      // tear down
    });
  });
}
