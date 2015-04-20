@TestOn('vm')
library bwu_utils.test.testing.web_driver;

import 'package:bwu_utils/testing_server.dart';

final _log = new Logger('bwu_utils.test.testing.web_driver');

main([List<String> args]) async {
  initLogging(args);

  DriverFactory wdFactory = createDriverFactory();
  await wdFactory.startFactory();

  group('web_driver', () {
    WebDriver driver;
    PubServe pubServe;
    int finishedTestCount = 0;
    int startedTestCount = 0;

    setUp(() async {
      startedTestCount++;
      //if (pubServe == null) {
      print('setUp');
      pubServe = new PubServe();
      await pubServe.start(directories: const ['test']);
      driver = await wdFactory.createDriver();
      print('driver = $driver');
      //}
    });

    tearDown(() async {
      finishedTestCount++;
      if(finishedTestCount == startedTestCount) {
        print('tearDown');
      }
      print('closing driver ${wdFactory}');
      await driver.quit();

      print('closing server');
      pubServe.stop();
      return wdFactory.stopFactory();
      //}
    });

    test('simple', () async {
      final pubServePort = pubServe.directoryPorts['test'];
      final url = 'http://localhost:${pubServePort}/testing/sample_html.html';
      print('get: ${url}');
      await driver.get(url);
      await new Future.delayed(new Duration(seconds: 1), () {});
      String title = await driver.title;
      print('title: $title');
      expect(title, startsWith('Sample page for WebDriver test.'));
    }, timeout: const Timeout(const Duration(minutes: 5)));
  });
}
