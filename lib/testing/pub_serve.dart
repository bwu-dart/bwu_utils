library bwu_utils.testing.server.pub_serve;

import 'dart:io' as io;
import 'dart:async' show Completer, Future, Stream, StreamController;
import 'dart:convert' show Utf8Decoder, UTF8, Utf8Codec, LineSplitter;
import 'dart:collection' show UnmodifiableMapView;
import 'package:bwu_utils/server/network/network.dart' show getFreeIpPort;
import 'package:bwu_utils/server/package/package.dart' as pkg;
import 'package:logging/logging.dart' show Logger;

final _log = new Logger('bwu_utils.testing.server.pub_serve');

class PubServe extends RunProcess {
  int _port;
  final _directoryPorts = <String, int>{};
  Map<String, int> get directoryPorts =>
      new UnmodifiableMapView(_directoryPorts);
  final _servingMessageRegex = new RegExp(
      r'^Serving [0-9a-zA-Z_]+ ([0-9a-zA-Z_]+) +on https?://.*:(\d{4,5})$');

  Future start({int port, directories: const ['test']}) async {
    final readyCompleter = new Completer<io.Process>();
    if (port != null && port > 0) {
      _port = port;
    } else {
      _port = await getFreeIpPort();
    }
    if (directories == null || directories.isEmpty) {
      directories = ['test'];
    }
    directories.forEach((d) => _directoryPorts[d] = null);
    String packageRoot = pkg.packageRoot().path;
    //_process = await io.Process.start(
    await super._run('pub', ['serve', '--port=${_port}']..addAll(directories),
        workingDirectory: packageRoot);
    exitCode.then((exitCode) {
      _port = null;
    });
    stdout
        .transform(UTF8.decoder)
        .transform(new LineSplitter())
        .listen((s) {
      //_log.fine(s);
      print(s);
      final match = _servingMessageRegex.firstMatch(s);
      if (match != null) {
        _directoryPorts[match.group(1)] = int.parse(match.group(2));
      }
      if (!readyCompleter.isCompleted &&
          !_directoryPorts.values.contains(null)) {
        readyCompleter.complete(process);
      }
    });
    stderr.transform(UTF8.decoder).listen(print);
    return readyCompleter.future;
  }
}

class SeleniumStandaloneServer extends RunProcess {
  Future start(String serverJarPath, {List<String> args, String workingDirectory}) async {
    //String jar = '/usr/local/apps/webdriver/selenium-server-standalone-2.45.0.jar';
    // -Dwebdriver.chrome.bin=/usr/bin/google-chrome -Dwebdriver.chrome.driver=/usr/local/apps/webdriver/chromedriver/2.15/chromedriver_linux64/chromedriver
    await super._run('java', ['-jar', serverJarPath]..addAll(args), workingDirectory: workingDirectory);
  }
}

class RunProcess {
  io.Process _process;
  io.Process get process => _process;

  Stream<List<int>>_stdoutStream;
  Stream<List<int>> get stdout => _stdoutStream;

  Stream<List<int>> _stderrStream;
  Stream<List<int>> get stderr => _stderrStream;

  Future<int> _exitCode;
  Future<int> get exitCode => _exitCode;

  Future _run(String executable, List<String> args, {String workingDirectory}) async {
    if (process != null) {
      return process;
    }
    _process = await io.Process.start(executable, args, workingDirectory: workingDirectory);
    _exitCode = process.exitCode;
    process.exitCode.then((exitCode) {
      _process = null;
    });

    _stdoutStream = process.stdout.asBroadcastStream();
    _stderrStream  =process.stderr.asBroadcastStream();
  }

  bool stop() {
    if (process != null) {
      return process.kill(io.ProcessSignal.SIGTERM);
    }
    return false;
  }
}
