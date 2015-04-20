library bwu_utils.testing.server.web_driver;

import 'dart:io' as io;
import 'dart:async' show Completer, Future, Stream;
import 'package:webdriver/webdriver.dart';
export 'package:webdriver/webdriver.dart';
import 'package:which/which.dart';

DriverFactory createDriverFactory() {
  List<DriverFactory> factories = [
    new SauceLabsDriverFactory(),
    new ChromeDriverFactory(),
    new PhantomJSDriverFactory(),
  ];

  DriverFactory factory;

  for (DriverFactory f in factories) {
    if (f.isAvailable) {
      factory = f;
      break;
    }
  }

  if (factory == null) {
    print('No webdriver candidates found.');
    print('Either set up the env. variables for using saucelabs, or install '
        'chromedriver or phantomjs.');
    io.exit(1);
  }
  return factory;
}

abstract class DriverFactory {
  final String name;

  DriverFactory(this.name);

  bool get isAvailable;

  Future startFactory();
  Future stopFactory();

  Future<WebDriver> createDriver();

  String toString() => name;
}

class SauceLabsDriverFactory extends DriverFactory {
  SauceLabsDriverFactory() : super('saucelabs');

  bool get isAvailable => false;

  Future startFactory() => new Future.value();
  Future stopFactory() => new Future.value();

  Future<WebDriver> createDriver() => new Future.error('not implemented');
}

class PhantomJSDriverFactory extends DriverFactory {
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

  Future<WebDriver> createDriver() {
    return WebDriver.createDriver(
        uri: Uri.parse('http://127.0.0.1:9515/wd'),
        desiredCapabilities: Capabilities.chrome);
  }
}

class ChromeDriverFactory extends DriverFactory {
  io.Process _process;

  ChromeDriverFactory() : super('chromedriver');

  bool get isAvailable => whichSync('chromedriver', orElse: () => null) != null;

  Future startFactory() {
    print('starting chromedriver');

    return io.Process.start('chromedriver', []).then((p) {
      _process = p;
      return new Future.delayed(new Duration(seconds: 1));
    });
  }

  Future stopFactory() {
    print('stopping chromedriver');

    _process.kill();
    Future f = _process.exitCode;
    _process = null;
    return f;
  }

  Future<WebDriver> createDriver() {
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

    return WebDriver.createDriver(
        uri: Uri.parse('http://127.0.0.1:9515/wd'),
        desiredCapabilities: capabilities);
  }
}
