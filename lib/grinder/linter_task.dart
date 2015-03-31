library bwu_utils.grinder.linter_task;

import 'dart:io' as io;
import 'package:linter/src/linter.dart';
import 'package:linter/src/formatter.dart';
import 'package:linter/src/io.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:grinder/grinder.dart';
import 'package:linter/src/config.dart';

/// Run linter using on the package.
/// Use the configuration file referenced by [configFilePath]
///   for example 'tool/lintcfg.yaml'.
void linterTask(String configFilePath) {
  final config =
  new LintConfig.parse(new io.File('tool/lintcfg.yaml').readAsStringSync());
  final lintOptions = new LinterOptions()..configure(config);
  final linter = new DartLinter(lintOptions);
  List<io.File> filesToLint = [];
  filesToLint.addAll(collectFiles(io.Directory.current.absolute.path));

  List<AnalysisErrorInfo> errors = linter.lintFiles(filesToLint);

  final commonRoot = io.Directory.current.absolute.path;
  ReportFormatter reporter = new ReportFormatter(
      errors, lintOptions.filter, outSink,
      fileCount: filesToLint.length,
      fileRoot: commonRoot,
      showStatistics: true);
  reporter.write();
  final linterErrorCount = (reporter as DetailedReporter).errorCount;
  if (linterErrorCount != 0) {
    context.fail('Linter reports ${linterErrorCount} errors');
  }
}
