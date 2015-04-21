library bwu_utils.testing.server;

export 'dart:async' show Future, Stream, Completer;
export 'package:test/test.dart';
export 'package:logging/logging.dart' show Logger, Level;

import 'package:args/args.dart';
import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:logging/logging.dart'
    show Logger, Level, hierarchicalLoggingEnabled;
import 'package:quiver_log/log.dart' show BASIC_LOG_FORMATTER, PrintAppender;
import 'package:bwu_utils/bwu_utils_server.dart' as srv_utils;
import 'dart:io' as io;
import 'package:path/path.dart' as path;

final _log = new Logger(' bwu_utils.testing.server');

void initLogging([List<String> args]) {
  final levels = Level.LEVELS.map((l) => l.toString().toLowerCase()).toList();
  final _parser = new ArgParser()
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Shows this usage information')
    ..addOption('loglevel',
        abbr: 'l',
        help: 'Specify the minimum logging level',
        allowed: levels,
        defaultsTo: Level.SEVERE.name.toLowerCase(),
        allowedHelp: new Map.fromIterable(levels, key: (key) => key));

  ArgResults options;
  try {
    options = _parser.parse(args != null ? args : []);
  } on FormatException catch (error) {
    _log.severe('Invalid arguments (${error.message}');
    _log.info(_parser.usage);
    return;
  }

  if (options["help"]) {
    _log.info(_parser.usage);
    return;
  }

  String loggingLevel = options['loglevel'];
  if (loggingLevel != null) {
    Logger.root.level = Level.LEVELS.firstWhere(
        (l) => l.name == loggingLevel.toUpperCase(),
        orElse: () => Level.SEVERE);
  }

  //Logger.root.level = Level.FINEST;
  hierarchicalLoggingEnabled = true;
  var appender = new PrintAppender(BASIC_LOG_FORMATTER);
  appender.attachLogger(Logger.root);
}

dynamic stackTrace(Logger _log, test()) {
  return Chain.capture(() => test(), onError: (error, stack) {
    _log.shout(error);
    _log.info(stack.terse);
    throw error;
  });
}

String _tmpTestDataDir;
String get tmpTestDataDir {
  if (_tmpTestDataDir == null) {
    _tmpTestDataDir =
        path.join(srv_utils.packageRoot().absolute.path, 'test/.tmp_data');
    if (!new io.Directory(_tmpTestDataDir).existsSync()) {
      throw 'Directory for temporary test data (${_tmpTestDataDir}) doesn\'t exist';
    }
  }
  return _tmpTestDataDir;
}
