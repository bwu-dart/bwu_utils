library bwu_utils.grinder.dartformat_task;

import 'dart:io' as io;
import 'package:grinder/grinder.dart';
import 'package:dart_style/src/io.dart' as fmt;
import 'package:dart_style/src/formatter_options.dart';

/// Check whether all *.dart files in the given directories and their sub-
/// directories are properly formatted.
void checkFormatTask(List<String> directories) {
  final reporter = OutputReporter.dryRun;
  // TODO(zoechi) currently there is no way to get notified about violations
  if (!formatAll(reporter, directories)) {
    context.fail('Formatting insufficient!');
  }
}

///
void formatAllTask(List<String> directories) {
  final reporter = OutputReporter.overwrite;
  if (!formatAll(reporter, directories)) {
    context.fail('Formatting failed!');
  }
}

/// helper for check-format and format-all
bool formatAll(OutputReporter reporter, List<String> directories) {
  return (directories
      .map((dir) => fmt.processDirectory(
          new FormatterOptions(reporter), new io.Directory(dir)))
      .reduce((e, e2) => e && e2));
}
