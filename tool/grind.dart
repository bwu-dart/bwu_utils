library bwu_utils.tool.grind;

import 'dart:io' as io;
import 'dart:async' show Future, Stream;
import 'dart:convert' show Utf8Decoder;
import 'package:grinder/grinder.dart';
import 'package:bwu_utils/grinder.dart';
//import 'package:bwu_utils/bwu_utils_server.dart' show getFreeIpPort;
import 'package:bwu_utils/testing_server.dart';


// TODO(zoechi) check if version was incremented
// TODO(zoechi) check if CHANGELOG.md contains version

main(List<String> args) => grind(args);

//@Task('Delete build directory')
//void clean() => defaultClean(context);

@Task('Run analyzer')
analyze() => new PubApp.global('tuneup').run(['check']);
//  analyzerTask(files: [], directories: ['lib', 'tool', 'test']);

@Task('Runn all tests')
test() => new PubApp.local('test').run(
    ['-pvm', '-pdartium' /*, '-pchrome', '-pphantomjs', '-pfirefox'*/]);
// TODO(zoechi) enable Polymer tests in JavaScript-only browsers when they are supported.

@Task('Run all VM tests')
testIo() => _test(['vm']);

@Task('Run all browser tests')
testHtml() => _test(['content-shell'], runPubServe: true);

testAll() => _test(['vm', 'content-shell', 'chrome', 'phantomjs', 'firefox']);

Future _test(List<String> platforms, {bool runPubServe: true}) async {
  if (runPubServe) {
    PubServe pubServe;
    try {
      pubServe = new PubServe();
      print('start pub serve');
      await pubServe.start(directories: const ['test']);
      print('pub serve started');
      pubServe.stdout.listen(io.stdout.add);
      pubServe.stderr.listen(io.stderr.add);

      new PubApp.local('test')..run(['--pub-serve=${pubServe.directoryPorts['test']}']
        ..addAll(platforms.map((p) => '-p${p}')));
    } catch(e) {
      pubServe.stop();
      final exitCode = await pubServe.exitCode;
      if (exitCode != null && exitCode != 0) {
        //context.fail('Pub serve failed with exit code ${exitCode}.');
      }
      rethrow;
    }
  } else {
    new PubApp.local('test').run(platforms.map((p) => '-p${p}').toList());
  }
}

@Task('Selenium-tests')
testSelenium() async {
  final seleniumJar = '/usr/local/apps/webdriver/selenium-server-standalone-2.45.0.jar';
//  final chromeBin = '-Dwebdriver.chrome.bin=/usr/bin/google-chrome';
//  final chromeDriverBin = '-Dwebdriver.chrome.driver=/usr/local/apps/webdriver/chromedriver/2.15/chromedriver_linux64/chromedriver';
  final platforms = ['vm'];
  final tests = ['test/testing/webdriver'];
  final selenium = new SeleniumStandaloneServer();
  try {
    await selenium.start(seleniumJar, args: []);
    new PubApp.local('test')..run([/*'--pub-serve=${pubServe.directoryPorts['test']}'*/]
      ..addAll(platforms.map((p) => '-p${p}'))..addAll(tests));
  } catch(e) {
    selenium.stop();
    final exitCode = await selenium.exitCode;
    if (exitCode != null && exitCode != 0) {
      //context.fail('Pub serve failed with exit code ${exitCode}.');
    }
    rethrow;
  }
}

@Task('Check everything')
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
