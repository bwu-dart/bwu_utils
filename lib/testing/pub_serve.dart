library bwu_utils.testing.server.pub_serve;

import 'dart:io' as io;
import 'dart:async' show Completer, Future, Stream, StreamController;
import 'dart:convert' show Utf8Decoder, UTF8, Utf8Codec, LineSplitter;
import 'dart:collection' show UnmodifiableMapView;
import 'package:bwu_utils/server/network/network.dart' show getFreeIpPort;
import 'package:bwu_utils/server/package/package.dart' as pkg;
import 'package:logging/logging.dart' show Logger;

final _log = new Logger('bwu_utils.testing.server.pub_serve');

class PubServe {
  io.Process _process;
  io.Process get process => _process;

  Stream<List<int>>_stdoutStream;
  Stream<List<int>> get stdout => _stdoutStream;

  Stream<List<int>> _stderrStream;
  Stream<List<int>> get stderr => _stderrStream;

  int _port;
  final _directoryPorts = <String, int>{};
  Map<String, int> get directoryPorts =>
      new UnmodifiableMapView(_directoryPorts);
  final _servingMessageRegex = new RegExp(
      r'^Serving [0-9a-zA-Z_]+ ([0-9a-zA-Z_]+) +on https?://.*:(\d{4,5})$');

  Future<int> _exitCode;
  Future<int> get exitCode => _exitCode;

  Future<io.Process> start({int port, directories: const ['test']}) async {
    final readyCompleter = new Completer<io.Process>();
    if (process != null) {
      return process;
    }
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
    _process = await io.Process.start(
        'pub', ['serve', '--port=${_port}']..addAll(directories),
        workingDirectory: packageRoot);
    _exitCode = process.exitCode;
    process.exitCode.then((exitCode) {
      _process = null;
      _port = null;
    });
    _log.fine('pub serve is serving on port "${_port}".');
    _stdoutStream = process.stdout.asBroadcastStream();
    _stderrStream  =process.stderr.asBroadcastStream();
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

  bool stop() {
    if (process != null) {
      return process.kill(io.ProcessSignal.SIGTERM);
    }
    return false;
  }
}
