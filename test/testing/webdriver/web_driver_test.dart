@TestOn('vm')
library bwu_utils.test.testing.web_driver;

import 'package:logging/logging.dart' show Logger;
import 'package:bwu_utils/testing_server.dart';

final _log = new Logger('bwu_utils.test.testing.web_driver');

main([List<String> args]) {
  initLogging(args);

  WebDriverFactory wdFactory = createDriverFactory();

  group('web_driver', () {
    WebDriver driver;
    PubServe pubServe;
    int finishedTestCount = 0;
    int startedTestCount = 0;

    setUp(() async {
      startedTestCount++;
      await wdFactory.startFactory();
      //if (pubServe == null) {
      pubServe = new PubServe();
      await pubServe.start(directories: const ['test']);
      driver = await wdFactory.createWebDriver();
      _log.fine('driver = $driver');
      //}
    });

    tearDown(() async {
      finishedTestCount++;
      if (finishedTestCount == startedTestCount) {
        _log.finest('tearDown');
      }
      _log.finest('closing driver ${wdFactory}');
      await driver.quit();

      _log.finest('closing server');
      pubServe.stop();
      return wdFactory.stopFactory();
      //}
    });

    test('simple', () async {
      // set up
      final pubServePort = pubServe.directoryPorts['test'];
      final url =
          'http://localhost:${pubServePort}/testing/webdriver/sample_html.html';

      // exercise
      _log.finest('get: ${url}');
      await driver.navigate.to(url);
      await new Future.delayed(new Duration(seconds: 1), () {});
      final title = await driver.title;

      // verification
      expect(title, startsWith('Sample page for WebDriver test.'));

      // tear down
    }, timeout: const Timeout(const Duration(minutes: 5)));
  });
}
