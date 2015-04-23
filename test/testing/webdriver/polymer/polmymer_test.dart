@Timeout(const Duration(minutes: 5))
@TestOn('vm')
library bwu_utils.test.testing.webdriver.polymer;

import 'package:bwu_utils/testing_server.dart';

final _log = new Logger('bwu_utils.test.testing.webdriver.polymer');

main([List<String> args]) {
  initLogging(args);
  WebDriverFactory wdFactory = createDriverFactory();

  group('x', () {
    WebDriver driver;
    PubServe pubServe;
//    int finishedTests;

    setUp(() async {
//      if (pubServe == null) {
        await wdFactory.startFactory();
        pubServe = new PubServe();
        await pubServe.start(directories: const ['test']);
  //    }
      driver = await wdFactory.createWebDriver();
      print('driver = $driver, ${driver.capabilities}, ${driver.id}');
    });

    tearDown(() async {
//      finishedTests++;
      //if(finishedTests >= test.length) {
//        print('closing driver ${wdFactory}');
      await driver.quit();

//        print('closing server');
      pubServe.stop();
      final ec = await wdFactory.stopFactory();
      print('exitCode: ${ec}');
      //}
    });

    test('', () async {
      // set up
      final examplePubServePort = pubServe.directoryPorts['test'];
      final url =
          'http://localhost:${examplePubServePort}/testing/webdriver/polymer/index.html';
      print(url);
      // exercise
      _log.finest('get: ${url}');
      await driver.get(url);
//      await driver.get(url);
      driver.timeouts.setImplicitTimeout(const Duration(seconds: 50));
      final title = await driver.title;
//      await new Future.delayed(new Duration(seconds: 100), () {});
//      await waitFor(
//          () => driver.findElement(const By.cssSelector('* /deep/ #some-div')),
//          matcher: isNot(throws),
//          timeout: const Duration(seconds: 40),
//          interval: const Duration(seconds: 5));
      await new Future.delayed(const Duration(milliseconds: 500), (){});
//      final someDiv =
//          await driver.findElement(const By.cssSelector('#granny'));
      final WebElement someDiv =
          await driver.findElement(const By.cssSelector('* #some-div'));

      //driver.timeouts.setImplicitTimeout(const Duration(seconds: 1));
      // verification
      expect(title, equals('browser/webdriver test'));
      expect(someDiv, isNotNull);
      expect(await someDiv.attributes['id'], equals('some-div'));

      // tear down
    }, timeout: const Timeout(const Duration(minutes: 5)));
  });
}
