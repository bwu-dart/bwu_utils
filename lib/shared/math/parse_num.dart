library bwu_utils.shared.math.parse_num;

import 'package:logging/logging.dart' show Logger;

final _log = new Logger('bwu_utils.shared.math.parse_num');

bool isInt(dynamic s, {int radix: 10}) {
  // TODO test after change to dynamic
  if (s == null) return false;
  if (s is int) return true;
  if (s is! String) return false;
  return parseInt(s, onErrorDefault: null) is int;
}

bool isDouble(dynamic s,
    {bool acceptInfinity: false, bool acceptNegativeInfinity: false}) {
  if (s == null) return false;
  if (s is num) {
    return (s != double.INFINITY || s == double.INFINITY && acceptInfinity) ||
        (s != double.NEGATIVE_INFINITY ||
            s == double.NEGATIVE_INFINITY && acceptNegativeInfinity);
  }
  if (s is! String) return false;
  num parsed = parseNum(s,
      onErrorDefault: null,
      acceptInfinity: acceptInfinity,
      acceptNegativeInfinity: acceptNegativeInfinity);
  return parsed != null &&
          (parsed.toString().contains('.') ||
              parsed.toString().contains('e')) ||
      (acceptInfinity && parsed.toString() == double.INFINITY.toString()) ||
      (acceptNegativeInfinity &&
          parsed.toString() == double.NEGATIVE_INFINITY.toString());
}

bool isNum(dynamic s,
    {bool acceptInfinity: false, bool acceptNegativeInfinity: false}) {
  if (s == null) return false;
  if (s is num) {
    return (s != double.INFINITY || s == double.INFINITY && acceptInfinity) ||
        (s != double.NEGATIVE_INFINITY ||
            s == double.NEGATIVE_INFINITY && acceptNegativeInfinity);
  }
  if (s is! String) return false;
  return parseNum(s,
      onErrorDefault: null,
      acceptInfinity: acceptInfinity,
      acceptNegativeInfinity: acceptNegativeInfinity) is num;
}

/// parse the provided value and return a default value in case of a FormatException
int parseInt(dynamic s, {int radix: 10, int onErrorDefault: null}) {
  if (s == null) return onErrorDefault;
  if (s is int) return s;
  if (s is! String) return onErrorDefault;
  return int.parse(s, radix: radix, onError: (_) => onErrorDefault);
}

double parseDouble(dynamic s,
    {double onErrorDefault: null,
    bool acceptInfinity: false,
    bool acceptNegativeInfinity: false}) {
  if (s == null) return onErrorDefault;
  if (s is num &&
      ((s != double.INFINITY || s == double.INFINITY && acceptInfinity) ||
          (s != double.NEGATIVE_INFINITY ||
              s == double.NEGATIVE_INFINITY && acceptNegativeInfinity))) {
    return s;
  } else {
    s = s.toString();
  }
  if (s is! String) return onErrorDefault;

  if (acceptInfinity &&
      s.toLowerCase() == double.INFINITY.toString().toLowerCase()) {
    return double.INFINITY;
  }

  if (acceptNegativeInfinity &&
      s.toLowerCase() == double.NEGATIVE_INFINITY.toString().toLowerCase()) {
    return double.NEGATIVE_INFINITY;
  }
  if (s is num &&
      ((s != double.INFINITY || s == double.INFINITY && acceptInfinity) ||
          (s != double.NEGATIVE_INFINITY ||
              s == double.NEGATIVE_INFINITY && acceptNegativeInfinity))) {
    return s;
  } else {
    s = s.toString();
  }
  if (s is! String) return onErrorDefault;

  double result = double.parse(s, (_) => onErrorDefault);

  if (result.toString() == double.NAN.toString()) return onErrorDefault;
  if (!acceptInfinity && result == double.INFINITY) return onErrorDefault;
  if (!acceptNegativeInfinity &&
      result == double.NEGATIVE_INFINITY) return onErrorDefault;

  return result;
}

num parseNum(dynamic s,
    {num onErrorDefault: null,
    bool acceptInfinity: false,
    bool acceptNegativeInfinity: false}) {
  if (s == null) return onErrorDefault;
  if (s is num &&
      ((s != double.INFINITY || s == double.INFINITY && acceptInfinity) ||
          (s != double.NEGATIVE_INFINITY ||
              s == double.NEGATIVE_INFINITY && acceptNegativeInfinity))) {
    return s;
  } else {
    s = s.toString();
  }
  if (s is! String) return onErrorDefault;

  if (acceptInfinity &&
      s.toLowerCase() == double.INFINITY.toString().toLowerCase()) {
    return double.INFINITY;
  }

  if (acceptNegativeInfinity &&
      s.toLowerCase() == double.NEGATIVE_INFINITY.toString().toLowerCase()) {
    return double.NEGATIVE_INFINITY;
  }

  num result = num.parse(s, (_) => onErrorDefault);

  if (result.toString() == double.NAN.toString()) return onErrorDefault;
  if (!acceptInfinity && result == double.INFINITY) return onErrorDefault;
  if (!acceptNegativeInfinity &&
      result == double.NEGATIVE_INFINITY) return onErrorDefault;

  return result;
}

class ParseResult<T> {
  final T value;
  final String unit;
  final bool isError;
  const ParseResult(this.value, this.unit, {this.isError: false});

  @override
  String toString() {
    if (isError) {
      return super.toString() + ' isError: true';
    }
    return '${value}${unit}';
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! ParseResult) return false;
    return other.value == value &&
        other.unit == unit &&
        other.isError == isError;
  }

  @override
  int get hashCode => '${value}${unit}${isError}'.hashCode;
}

/// Parses Strings with number and unit suffix.
/// Only numbers in decimal form without a comma are supported.
ParseResult<int> parseIntWithUnit(String s) {
  Match comma = new RegExp(r'(?:\s*-?[0-9]*)\.|,(?:[0-9]*)').firstMatch(s);

  if (comma != null) return new ParseResult<int>(null, s, isError: true);

  Match m = new RegExp(r'(?:\s*)(-?[0-9]+)(?:\s*)([^\s]*)').firstMatch(s);

  if (m == null || m.groupCount == 0) {
    return new ParseResult<int>(null, s, isError: true);
  }
  int numValue = parseInt(m.group(1));
  if (numValue == null) {
    return new ParseResult<int>(null, s, isError: true);
  }
  return new ParseResult<int>(numValue, m.group(2).trim());
}

/// Parses Strings with number and unit suffix.
/// Only numbers in decimal form are supported.
ParseResult<double> parseDoubleWithUnit(String s) {
  Match m =
      new RegExp(r'(?:\s*)(-?[0-9]*\.?[0-9]*)(?:\s*)([^\s]*)').firstMatch(s);

  if (m == null || m.groupCount == 0) {
    return new ParseResult<double>(null, s, isError: true);
  }
  double numValue = parseDouble(m.group(1));
  if (numValue == null) {
    return new ParseResult<double>(null, s, isError: true);
  }
  return new ParseResult<double>(numValue, m.group(2).trim());
}

/// Parses Strings with number and unit suffix.
/// Only numbers in decimal form are supported.
ParseResult<num> parseNumWithUnit(String s) {
  Match m =
      new RegExp(r'(?:\s*)(-?[0-9]*\.?[0-9]*)(?:\s*)([^\s]*)').firstMatch(s);

  if (m == null || m.groupCount == 0) {
    return new ParseResult<num>(null, s, isError: true);
  }
  num numValue = parseNum(m.group(1));
  if (numValue == null) {
    return new ParseResult<num>(null, s, isError: true);
  }
  return new ParseResult<num>(numValue, m.group(2).trim());
}

int parseIntDropUnit(String s) {
  if (s == null || s.trim() == '') {
    return 0;
  }
  if (s.endsWith('%')) {
    s = s.substring(0, s.length - 1);
  } else if (s.endsWith('px')) {
    s = s.substring(0, s.length - 2);
  }
  try {
    return num.parse(s).round();
  } on FormatException catch (e) {
    _log.severe('message: ${e.message}; value: "${s}"');
    rethrow;
  }
}
