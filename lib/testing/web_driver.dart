library bwu_utils.testing.server.web_driver;

import 'dart:io' as io;
import 'dart:async' show Completer, Future, Stream;
import 'package:webdriver/io.dart';
export 'package:webdriver/io.dart';
export 'package:webdriver/async_helpers.dart';
import 'package:which/which.dart';
import 'package:bwu_utils/testing_server.dart';

final _log = new Logger('bwu_utils.testing.server.web_driver');

WebDriverFactory createDriverFactory() {
  List<WebDriverFactory> factories = [
    //new SauceLabsDriverFactory(),
//    new ChromeDriverFactory(),
    new PhantomJSDriverFactory(),
    //new FirefoxDriverFactory(),
  ];

  WebDriverFactory factory;

  for (WebDriverFactory f in factories) {
    if (f.isAvailable) {
      factory = f;
      break;
    }
  }

  if (factory == null) {
    _log.severe('No webdriver candidates found.');
    _log.severe('Either set up the env. variables for using saucelabs, or install '
        'chromedriver or phantomjs.');
    io.exit(1);
  }
  return factory;
}

abstract class WebDriverFactory {
  final String name;

  WebDriverFactory(this.name);

  Map get _env => io.Platform.environment;
  bool get isAvailable;

  Future startFactory();
  Future stopFactory();

  Future<WebDriver> createWebDriver();

  String toString() => name;
}

class SauceLabsDriverFactory extends WebDriverFactory {
  SauceLabsDriverFactory() : super('saucelabs');

  bool get isAvailable => _env.containsKey('SAUCE_USERNAME') && _env.containsKey('SAUCE_ACCESS_KEY');

  Future startFactory() => new Future.value();
  Future stopFactory() => new Future.value();

  Future<WebDriver> createWebDriver() => new Future.error('not implemented');
}

class PhantomJSDriverFactory extends WebDriverFactory {
  io.Process _process;

  PhantomJSDriverFactory() : super('phantomjs');

  bool get isAvailable => whichSync('phantomjs', orElse: () => null) != null;

  Future startFactory() {
    return io.Process.start('phantomjs', ['--webdriver=9515']).then((p) {
      _process = p;
      return new Future.delayed(new Duration(seconds: 1));
    });
  }

  Future stopFactory() {
    _process.kill();
    Future f = _process.exitCode;
    _process = null;
    return f;
  }

  Future<WebDriver> createWebDriver() {
    return createDriver(
        uri: Uri.parse('http://127.0.0.1:9515/wd'),
        desired: Capabilities.chrome);
  }
}

class FirefoxDriverFactory extends WebDriverFactory {
  io.Process _process;

  FirefoxDriverFactory() : super('firefox');

  bool get isAvailable => whichSync('firefox', orElse: () => null) != null;

  Future startFactory() {
    return io.Process.start('firefox', ['--webdriver=9515']).then((p) {
      _process = p;
      return new Future.delayed(new Duration(seconds: 1));
    });
  }

  Future stopFactory() {
    _process.kill();
    Future f = _process.exitCode;
    _process = null;
    return f;
  }

  Future<WebDriver> createWebDriver() {
    Map capabilities = Capabilities.firefox;
    //capabilities['FirefoxDriver.PROFILE'] = 'WebDriver';
    //capabilities['profile'] = 'WebDriver';
    capabilities['webdriver.firefox.profile'] = 'WebDriver';
    //Map firefoxOptions = {'args': ['-p', 'WebDriver']};
    //capabilities['firefoxOptions'] = firefoxOptions;
    return createDriver(
        uri: Uri.parse('http://127.0.0.1:4444/wd/hub/'),
        desired: capabilities);
  }
}

class ChromeDriverFactory extends WebDriverFactory {
  io.Process _process;

  ChromeDriverFactory() : super('chromedriver');

  bool get isAvailable => whichSync('chromedriver', orElse: () => null) != null;

  Future startFactory() {
    _log.fine('starting chromedriver');

    return io.Process.start('chromedriver', []).then((p) {
      _process = p;
      return new Future.delayed(new Duration(seconds: 1));
    });
  }

  Future stopFactory() {
    _log.finest('stopping chromedriver');

    _process.kill();
    Future f = _process.exitCode;
    _process = null;
    return f;
  }

  Future<WebDriver> createWebDriver() {
    Map capabilities = Capabilities.chrome;
    Map env = io.Platform.environment;
    Map chromeOptions = {};

    if (env['CHROMEDRIVER_BINARY'] != null) {
      chromeOptions['binary'] = env['CHROMEDRIVER_BINARY'];
    }
    if (env['CHROMEDRIVER_ARGS'] != null) {
      chromeOptions['args'] = env['CHROMEDRIVER_ARGS'].split(' ');
    }
    if (chromeOptions.isNotEmpty) {
      capabilities['chromeOptions'] = chromeOptions;
    }

    return createDriver(
        uri: Uri.parse('http://127.0.0.1:9515/wd'),
        //uri: Uri.parse('http://127.0.0.1:4444/wd/hub/'),
        desired: capabilities);
  }
}
