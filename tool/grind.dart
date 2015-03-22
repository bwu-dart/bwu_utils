library bwu_utils.tool.grind;

import 'dart:io' as io;
import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:grinder/grinder.dart';
import 'package:grinder/grinder_files.dart';
import 'package:dart_style/src/io.dart' as fmt;
import 'package:dart_style/src/formatter_options.dart';
import 'package:linter/src/config.dart';
import 'package:linter/src/linter.dart';
import 'package:linter/src/formatter.dart';
import 'package:linter/src/io.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:bwu_utils/grinder.dart';

void main(List<String> args) {
  Chain.capture(() => _main(args), onError: (error, stack) {
    print(error);
    print(stack.terse);
  });
}

// TODO(zoechi) check if version was incremented
// TODO(zoechi) check if CHANGELOG.md contains version

_main(List<String> args) => grind(args);

@Task()
void init(GrinderContext context) => defaultInit(context);

@Task()
void clean(GrinderContext context) => defaultClean(context);

/// analyze - Analyzer check excluding tests
@Task()
@Depends(init)
void analyze(GrinderContext context) {
  final files = [];
  ['lib', 'tool'].forEach((dir) => files.addAll(
      new FileSet.fromDir(new io.Directory(dir), pattern: '*.dart').files
          .map((f) => f.absolute.path)));

  Analyzer.analyzePaths(context, files, fatalWarnings: true);
}

/// analyze-tests - Analyzer check test/**
@Task()
@Depends(init)
void analyzeTests(GrinderContext context) {
  final files = new FileSet.fromDir(new io.Directory('test'),
      pattern: '*.dart', recurse: true);
  assert(files.files.length > 0);

  Analyzer.analyzeFiles(context, files.files, fatalWarnings: true);
}

/// tests - Run all tests
@Task()
@Depends(init)
void test(GrinderContext context) {
  Tests.runCliTests(context);
}

@Task()
@Depends(init)
void testWeb(GrinderContext context) {
  var browser = new ContentShellDrt();
  Tests.runWebTests(context,
      directory: 'test/browser',
      htmlFile: 'parse_int_test.html',
      browser: browser);
}

/// check - thorough pre-publish check
@Task()
@Depends(init, analyze, analyzeTests, checkFormat, lint, test)
void check(GrinderContext context) {
  final fileSet = new FileSet.fromDir(new io.Directory('test'),
      pattern: '*.dart', recurse: true);
  assert(fileSet.files.length > 0);

  Analyzer.analyzeFiles(context, fileSet.files);
}

/// check-format - check all for formatting issues
@Task()
@Depends(init)
void checkFormat(GrinderContext context) {
  final reporter = OutputReporter.dryRun;
  // TODO(zoechi) currently there is no way to get notified about violations
  if (!_formatAll(reporter)) {
    context.fail('Formatting insufficient!');
  }
}

/// helper for check-format and format-all
bool _formatAll(OutputReporter reporter) {
  return (['tool', 'lib', 'test']
      .map((dir) => fmt.processDirectory(
          new FormatterOptions(reporter), new io.Directory(dir)))
      .reduce((e, e2) => e && e2));
}

/// format-all - fix all formatting issues
@Task()
@Depends(init)
void formatAll(GrinderContext context) {
  final reporter = OutputReporter.overwrite;
  if (!_formatAll(reporter)) {
    context.fail('Formatting failed!');
  }
}

/// lint - run linter on all files
@Task()
@Depends(init)
void lint(GrinderContext context) {
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
