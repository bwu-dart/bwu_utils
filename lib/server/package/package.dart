library bwu_utils.server.package;

import 'dart:io' as io;
import 'package:path/path.dart' as path;

/// Traverse upwards until `pubspec.yaml` is found and return the directory path.
/// We use paths relative to the package root, therefore we need to know where
/// the package root actually is.
/// This way the tests work when launched from IDE and for example from
/// test_runner.
io.Directory packageRoot([io.Directory startDir]) {
  if (startDir == null) {
    startDir = io.Directory.current;
  }
  final bool exists =
      new io.File(path.join(startDir.absolute.path, 'pubspec.yaml'))
          .existsSync();

  if (exists) return startDir;
  if (startDir.parent == startDir) return null;
  return packageRoot(startDir.parent);
}
