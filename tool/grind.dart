library bwu_utils.tool.grind;

//import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:grinder/grinder.dart';

import 'package:bwu_utils/grinder.dart';

//void main(List<String> args) {
//  Chain.capture(() => _main(args), onError: (error, stack) {
//    print(error);
//    print(stack.terse);
//  });
//}

// TODO(zoechi) check if version was incremented
// TODO(zoechi) check if CHANGELOG.md contains version

main(List<String> args) => grind(args);

//@Task('Delete build directory')
//void clean() => defaultClean(context);

@Task('Run analyzer')
analyze() => new PubApp.global('tuneup').run(['check']);
//  analyzerTask(files: [], directories: ['lib', 'tool', 'test']);

@Task('Runn all tests')
test() => new PubApp.local('test').run(['-pvm', '-pcontent-shell', '-pphantomjs']);

@Task('Run all browser tests')
testIo() => new PubApp.local('test').run(['-vm']);

@Task('Run all browser tests')
testHtml() => new PubApp.local('test').run(['-pcontent-shell']);

@Task('Run all checks (analyze, check-format, lint, test, test-web)')
@Depends(analyze, checkFormat, lint, test)
check() {}

@Task('Check source code format')
checkFormat() => checkFormatTask(['.']);

/// format-all - fix all formatting issues
@Task('Fix all source format issues')
formatAll() =>
    new PubApp.global('dart_style').run(['-w', '.'], script: 'format');

@Task('Run lint checks')
lint() =>
    new PubApp.global('linter').run(['--stats', '-ctool/lintcfg.yaml', '.']);
//void lint() => linterTask('tool/lintcfg.yaml');
