library bwu_utils.testing.browser;

export 'dart:async' show Future, Stream, Completer;
export 'package:test/test.dart';
export 'package:logging/logging.dart' show Logger, Level;

import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:logging/logging.dart'
    show Logger, Level, hierarchicalLoggingEnabled;
import 'package:quiver_log/log.dart' show BASIC_LOG_FORMATTER, PrintAppender;

export 'package:bwu_utils/bwu_utils_browser.dart';

void initLogging() {
  Logger.root.level = Level.FINEST;
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
