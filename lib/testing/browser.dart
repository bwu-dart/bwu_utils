library bwu_utils.testing.server;

export 'dart:async' show Future, Stream, Completer;
export 'package:unittest/unittest.dart';
export 'package:logging/logging.dart'
    show Logger, Level;

import 'dart:async' show Future;
import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:logging/logging.dart'
    show Logger, Level, hierarchicalLoggingEnabled;
import 'package:quiver_log/log.dart' show BASIC_LOG_FORMATTER, PrintAppender;

import 'dart:html' as dom;
import 'package:path/path.dart' as path;

import 'package:bwu_utils/bwu_utils_browser.dart' as html_util;
export 'package:bwu_utils/bwu_utils_browser.dart';

void initLogging() {
  Logger.root.level = Level.FINEST;
  hierarchicalLoggingEnabled = true;
  var appender = new PrintAppender(BASIC_LOG_FORMATTER);
  appender.attachLogger(Logger.root);
}

dynamic stackTrace(Logger _log, test()) {
  return test();
  return Chain.capture(() => test() /*, onError: (error, stack) {
//    _log.shout(error);
//    _log.info(stack.terse);
    throw error;
  }*/);
}
