library bwu_utils.testing.server;

export 'dart:async' show Future, Stream;
export 'package:unittest/unittest.dart';
export 'package:logging/logging.dart' show Logger, Level;

import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:logging/logging.dart' show Logger, Level;
import 'package:quiver_log/log.dart' show BASIC_LOG_FORMATTER, PrintAppender;

import 'dart:io' as io;
import 'package:path/path.dart' as path;

import 'package:bwu_utils/bwu_utils_server.dart' as srv_util;
export 'package:bwu_utils/bwu_utils_server.dart';

void initLogging() {
  Logger.root.level = Level.FINEST;
  var appender = new PrintAppender(BASIC_LOG_FORMATTER);
  appender.attachLogger(Logger.root);
}

void stackTrace(Logger _log, void test()) {
  Chain.capture(() => test(), onError: (error, stack) {
    _log.shout(error);
    _log.info(stack.terse);
  });
}

io.Directory get packageRoot {
  return srv_util.packageRoot();
}

String _tmpTestDataDir;
String get tmpTestDataDir {
  if (_tmpTestDataDir == null) {
    _tmpTestDataDir = path.join(packageRoot.absolute.path, 'test/.tmp_data');
    if (!new io.Directory(_tmpTestDataDir).existsSync()) {
      throw 'Directory for temporary test data (${_tmpTestDataDir}) doesn\'t exist';
    }
  }
  return _tmpTestDataDir;
}
