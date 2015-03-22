library bwu_utils.test.server.package;

import 'package:unittest/unittest.dart';
import 'package:bwu_utils/bwu_utils_server.dart' show packageRoot;
import 'package:path/path.dart' as path;

void main() {
  group('package_test', () {
    test('package', () {
      // set up
      // exercise
      final dir = packageRoot();
      // verification
      expect(path.basename(dir.path), equals('bwu_utils'));
      // tear down
    });
  });
}
