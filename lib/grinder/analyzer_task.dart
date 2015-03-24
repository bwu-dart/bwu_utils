library bwu_utils.grinder.analyzer_task;

import 'dart:io' as io;
import 'package:grinder/grinder.dart';

void analyzerTask(GrinderContext context, {List<String> files: const [], List<String> directories: const []}) {
  final _files = []..addAll(files);
  directories.forEach((dir) => files.addAll(
      new FileSet.fromDir(new io.Directory(dir), pattern: '*.dart', recurse: true).files
          .map((f) => f.absolute.path)));

  Analyzer.analyzePaths(context, files, fatalWarnings: true);
}
