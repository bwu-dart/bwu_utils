library bwu_utils.tool.grind;

import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:grinder/grinder.dart';

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

//@Task('Delete build directory')
//void clean() => defaultClean(context);

@Task('Run analyzer')
void analyze() {
  analyzerTask(files: [], directories: ['lib', 'tool', 'test']);
//  PubApplication tuneup = new PubApplication('tuneup');
//  tuneup.run(['check']);
}

@Task('Runn all command line tests')
void test() => Tests.runCliTests();

@Task('Run all browser tests')
void testWeb() {
  var browser = new ContentShellDrt();
  Tests.runWebTests(
      directory: 'test/browser',
      htmlFile: 'parse_int_test.html',
      browser: browser);
}

@Task('Run all checks (analyze, check-format, lint, test, test-web)')
@Depends(analyze, checkFormat, lint, test)
void check() {}

@Task('Check source code format')
void checkFormat() => checkFormatTask(['.']);

/// format-all - fix all formatting issues
@Task('Fix all source format issues')
void formatAll() =>  checkFormatTask(['.']);

@Task('Run lint checks')
void lint() => linterTask('tool/lintcfg.yaml');
