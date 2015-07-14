@TestOn('vm')
library bwu_utils.test.server.package;

import 'package:test/test.dart';
import 'package:bwu_utils/bwu_utils_server.dart';

import 'package:path/path.dart' as path;

void main([List<String> args]) {
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
