library bwu_utils.test_parse_num;

import 'package:unittest/unittest.dart';

import 'package:bwu_utils/math/parse_num.dart';

void main(args) {
  group('parse int -', () {
    test('return null', () {
      expect(parseInt(null), isNull);
      expect(parseInt('null'), isNull);
      expect(parseInt(''), isNull);
    });

    test('return onErrorDefault', () {
      expect(parseInt(null, onErrorDefault: null), isNull);
      expect(parseInt(null, onErrorDefault: 0), equals(0));
      expect(parseInt('null', onErrorDefault: null), isNull);
    });

    test('simple values', () {
      expect(parseInt('0'), equals(0));
      expect(parseInt('0.0'), isNull); // fails
      expect(parseInt('1'), equals(1));
      expect(parseInt('-1'), equals(-1));

      expect(parseInt('.1'), isNull);
      expect(parseInt('-.1'), isNull);
      expect(parseInt('1.'), isNull);
      expect(parseInt('-1.'), isNull);
      expect(parseInt('.'), isNull);


      int bigInt = 999999999999999999999999999999;
      expect(parseInt(bigInt.toString()), equals(bigInt));
      expect(parseInt('-${bigInt}'), equals(0 - bigInt));
      expect(parseInt('- ${bigInt}'), isNull); // fails

      expect(parseInt(double.NAN.toString()), isNull);
    });
  });

  group('parse double -', () {
    test('return null', () {
      expect(parseDouble(null), isNull);
      expect(parseDouble('null'), isNull);
      expect(parseDouble(''), isNull);
    });

    test('return onErrorDefault', () {
      expect(parseDouble(null, onErrorDefault: null), isNull);
      expect(parseDouble(null, onErrorDefault: 0.0), equals(0.0));
      expect(parseDouble('null', onErrorDefault: null), isNull);
      expect(parseDouble(null, onErrorDefault: double.MIN_POSITIVE), equals(double.MIN_POSITIVE));
    });

    test('simple values', () {
      expect(parseDouble('0'), equals(0.0)); // returns double but equals doesn't care
      expect(parseDouble('0.0'), equals(0));
      expect(parseDouble('0'), new isInstanceOf<double>()); // verify it actually returns double
      expect(parseDouble('0.0'), new isInstanceOf<double>());
      expect(parseDouble('1'), equals(1));
      expect(parseDouble('1.0'), equals(1.0));
      expect(parseDouble('-1'), equals(-1));
      expect(parseDouble('-1.0'), equals(-1.0));

      expect(parseDouble('.1'), equals(0.1));
      expect(parseDouble('-.1'), equals(-0.1));
      expect(parseDouble('1.'), equals(1.0));
      expect(parseDouble('-1.'), equals(-1.0));
      expect(parseDouble('.'), isNull);

      int bigInt = 999999999999999999999999999999;
      expect(parseDouble(bigInt.toString()), equals(bigInt));
      expect(parseDouble('-${bigInt}'), equals(0 - bigInt));
      expect(parseDouble('- ${bigInt}'), isNull);
      double bigDouble = 999999999999999999999999999999.999999999999999999999999999999;
      expect(parseDouble(bigDouble.toString()), equals(bigDouble));
      expect(parseDouble('-${bigDouble}'), equals(0 - bigDouble));
      expect(parseDouble('- ${bigDouble}'), isNull);

      expect(parseDouble('1,000.00'), isNull);
      expect(parseDouble('00.00'), equals(0.0));
    });

    test('Infinity, NaN', () {
      expect(parseDouble('infinity', acceptInfinity: true), double.INFINITY);
      expect(parseDouble('inFinity', acceptInfinity: true), double.INFINITY);
      expect(parseDouble('INFINITY', acceptInfinity: true), double.INFINITY);
      expect(parseDouble('Infinity', acceptInfinity: true), double.INFINITY);

      expect(parseDouble('Infinity', acceptNegativeInfinity: true), isNull);

      expect(parseDouble('-infinity', acceptNegativeInfinity: true), double.NEGATIVE_INFINITY);
      expect(parseDouble('-inFinity', acceptNegativeInfinity: true), double.NEGATIVE_INFINITY);
      expect(parseDouble('-Infinity', acceptNegativeInfinity: true), double.NEGATIVE_INFINITY);

      expect(parseDouble('-Infinity', acceptInfinity: true), isNull);
      logMessage('-infinity'.toLowerCase() + ' ' + double.NEGATIVE_INFINITY.toString().toLowerCase());

      expect(parseDouble(double.NAN.toString()), isNull);
    });
  });

  group('parse num -', () {
    test('return null', () {
      expect(parseNum(null), isNull);
      expect(parseNum('null'), isNull);
      expect(parseNum(''), isNull);
    });

    test('return onErrorDefault', () {
      expect(parseNum(null, onErrorDefault: null), isNull);
      expect(parseNum(null, onErrorDefault: 0.0), equals(0.0));
      expect(parseNum(null, onErrorDefault: 0), equals(0));
      expect(parseNum(null, onErrorDefault: 0xff), equals(0xff));
      expect(parseNum(null, onErrorDefault: double.MIN_POSITIVE), equals(double.MIN_POSITIVE));
      expect(parseNum('null', onErrorDefault: null), isNull);
    });

    test('simple values', () {
      expect(parseNum('0'), equals(0.0)); // returns double but equals doesn't care
      expect(parseNum('0.0'), equals(0));
      expect(parseNum('0'), new isInstanceOf<int>()); // verify it actually returns double
      expect(parseNum('0.0'), new isInstanceOf<double>());
      expect(parseNum('1'), equals(1));
      expect(parseNum('1.0'), equals(1.0));
      expect(parseNum('-1'), equals(-1));
      expect(parseNum('-1.0'), equals(-1.0));

      expect(parseNum('.1'), equals(0.1));
      expect(parseNum('-.1'), equals(-0.1));
      expect(parseNum('1.'), equals(1.0));
      expect(parseNum('-1.'), equals(-1.0));
      expect(parseNum('.'), isNull);

      int bigInt = 999999999999999999999999999999;
      expect(parseNum(bigInt.toString()), equals(bigInt));
      expect(parseNum('-${bigInt}'), equals(0 - bigInt));
      expect(parseNum('- ${bigInt}'), isNull);
      double bigDouble = 999999999999999999999999999999.999999999999999999999999999999;
      expect(parseNum(bigDouble.toString()), equals(bigDouble));
      expect(parseNum('-${bigDouble}'), equals(0 - bigDouble));
      expect(parseNum('- ${bigDouble}'), isNull);

      expect(parseNum('1,000.00'), isNull);
      expect(parseNum('00.00'), equals(0.0));
    });

    test('Infinity', () {
      expect(parseNum('infinity', acceptInfinity: true), double.INFINITY);
      expect(parseNum('inFinity', acceptInfinity: true), double.INFINITY);
      expect(parseNum('INFINITY', acceptInfinity: true), double.INFINITY);
      expect(parseNum('Infinity', acceptInfinity: true), double.INFINITY);

      expect(parseNum('Infinity', acceptNegativeInfinity: true), isNull);

      expect(parseNum('-infinity', acceptNegativeInfinity: true), double.NEGATIVE_INFINITY);
      expect(parseNum('-inFinity', acceptNegativeInfinity: true), double.NEGATIVE_INFINITY);
      expect(parseNum('-Infinity', acceptNegativeInfinity: true), double.NEGATIVE_INFINITY);

      expect(parseDouble('-Infinity', acceptInfinity: true), isNull);
    });
  });

  group('isInt -', () {
    test('return null', () {
      expect(isInt(null), isFalse);
      expect(isInt('null'), isFalse);
      expect(isInt(''), isFalse);
    });

    test('simple values', () {
      expect(isInt('0'), isTrue);
      expect(isInt('0.0'), isFalse);
      expect(isInt('1'), isTrue);
      expect(isInt('1.0'), isFalse);
      expect(isInt('-1'), isTrue);
      expect(isInt('-1.0'), isFalse);

      expect(isInt('.1'), isFalse);
      expect(isInt('-.1'), isFalse);
      expect(isInt('1.'), isFalse);
      expect(isInt('-1.'), isFalse);
      expect(isInt('.'), isFalse);

      int bigInt = 999999999999999999999999999999;
      expect(isInt(bigInt.toString()), isTrue);
      expect(isInt('-${bigInt}'), isTrue);
      expect(isInt('- ${bigInt}'), isFalse);

      expect(isInt('1,000'), isFalse);
      expect(isInt('00'), isTrue);
    });

    test('Infinity', () {
      expect(isInt('Infinity'), isFalse);
      expect(isInt('-Infinity'), isFalse);
    });
  });

  group('isDouble -', () {
    test('return null', () {
      expect(isDouble(null), isFalse);
      expect(isDouble('null'), isFalse);
      expect(isDouble(''), isFalse);
    });

    test('simple values', () {
      expect(isDouble('0'), isFalse);
      expect(isDouble('0.0'), isTrue);
      expect(isDouble('0.09'), isTrue);
      expect(isDouble('1'), isFalse);
      expect(isDouble('1.0'), isTrue);
      expect(isDouble('1.09'), isTrue);
      expect(isDouble('-1'), isFalse);
      expect(isDouble('-1.0'), isTrue);
      expect(isDouble('-1.09'), isTrue);

      expect(isDouble('.1'), isTrue);
      expect(isDouble('-.1'), isTrue);
      expect(isDouble('1.'), isTrue);
      expect(isDouble('-1.'), isTrue);
      expect(isDouble('.'), isFalse);

      double bigDouble = 999999999999999999999999999999.999999999999999999999999999999;
      expect(isDouble(bigDouble.toString()), isTrue);
      expect(isDouble('-${bigDouble}'), isTrue);
      expect(isDouble('- ${bigDouble}'), isFalse);

      expect(isDouble('1,000.00'), isFalse);
      expect(isDouble('00.00'), isTrue);
    });

    test('Infinity', () {
      expect(isDouble('infinity', acceptInfinity: true), isTrue);
      expect(isDouble('inFinity', acceptInfinity: true), isTrue);
      expect(isDouble('INFINITY', acceptInfinity: true), isTrue);
      expect(isDouble('Infinity', acceptInfinity: true), isTrue);

      expect(isDouble('Infinity', acceptNegativeInfinity: true), isFalse);

      expect(isDouble('-infinity', acceptNegativeInfinity: true), isTrue);
      expect(isDouble('-inFinity', acceptNegativeInfinity: true), isTrue);
      expect(isDouble('-Infinity', acceptNegativeInfinity: true), isTrue);

      expect(isDouble('-Infinity', acceptInfinity: true), isFalse);
    });
  });

  group('isNum -', () {
    test('return null', () {
      expect(isNum(null), isFalse);
      expect(isNum('null'), isFalse);
      expect(isNum(''), isFalse);
    });

    test('simple values', () {
      expect(isNum('0'), isTrue);
      expect(isNum('0.0'), isTrue);
      expect(isNum('0.09'), isTrue);
      expect(isNum('1'), isTrue);
      expect(isNum('1.0'), isTrue);
      expect(isNum('1.09'), isTrue);
      expect(isNum('-1'), isTrue);
      expect(isNum('-1.0'), isTrue);
      expect(isNum('-1.09'), isTrue);

      expect(isNum('.1'), isTrue);
      expect(isNum('-.1'), isTrue);
      expect(isNum('1.'), isTrue);
      expect(isNum('-1.'), isTrue);
      expect(isNum('.'), isFalse);

      int bigInt = 999999999999999999999999999999;
      expect(isInt(bigInt.toString()), isTrue);
      expect(isInt('-${bigInt}'), isTrue);
      expect(isInt('- ${bigInt}'), isFalse);
      double bigDouble = 999999999999999999999999999999.999999999999999999999999999999;
      expect(isNum(bigDouble.toString()), isTrue);
      expect(isNum('-${bigDouble}'), isTrue);
      expect(isNum('- ${bigDouble}'), isFalse);

      expect(isNum('1,000.00'), isFalse);
      expect(isNum('1,000'), isFalse);
      expect(isNum('00.00'), isTrue);
      expect(isNum('00'), isTrue);
    });

    test('Infinity', () {
      expect(isNum('infinity', acceptInfinity: true), isTrue);
      expect(isNum('inFinity', acceptInfinity: true), isTrue);
      expect(isNum('INFINITY', acceptInfinity: true), isTrue);
      expect(isNum('Infinity', acceptInfinity: true), isTrue);

      expect(isNum('Infinity', acceptNegativeInfinity: true), isFalse);

      expect(isNum('-infinity', acceptNegativeInfinity: true), isTrue);
      expect(isNum('-inFinity', acceptNegativeInfinity: true), isTrue);
      expect(isNum('-Infinity', acceptNegativeInfinity: true), isTrue);

      expect(isNum('-Infinity', acceptInfinity: true), isFalse);
    });
  });

  group('parseIntWithUnit -', () {
    test('simple', () {
      expect(parseIntWithUnit('10px'), equals(new ParseResult<int>(10, 'px')));
      expect(parseIntWithUnit('-10px'), equals(new ParseResult<int>(-10, 'px')));
      expect(parseIntWithUnit('10 px'), equals(new ParseResult<int>(10, 'px')));
      expect(parseIntWithUnit('10 px '), equals(new ParseResult<int>(10, 'px')));
      expect(parseIntWithUnit(' 10 px ').isError, isFalse);
      expect(parseIntWithUnit('10.0 px ').isError, isTrue);
      expect(parseIntWithUnit('10').isError, isFalse);
      expect(parseIntWithUnit('10 '), equals(new ParseResult<int>(10, '')));
      expect(parseIntWithUnit('px').isError, isTrue);
    });
  });

  group('parseDoubleWithUnit -', () {
    test('simple', () {
      expect(parseDoubleWithUnit('10px'), equals(new ParseResult<double>(10.0, 'px')));
      expect(parseDoubleWithUnit('10 px'), equals(new ParseResult<double>(10.0, 'px')));
      expect(parseDoubleWithUnit('10 px '), equals(new ParseResult<double>(10.0, 'px')));
      expect(parseDoubleWithUnit('10.px '), equals(new ParseResult<double>(10.0, 'px')));
      expect(parseDoubleWithUnit(' 10.0px '), equals(new ParseResult<double>(10.0, 'px')));

      expect(parseDoubleWithUnit('10.00. px ').isError, isFalse);

      expect(parseDoubleWithUnit('.0px '), equals(new ParseResult<double>(0.0, 'px')));

    });
  });

  group('parseNumWithUnit -', () {
    test('simple', () {
      expect(parseNumWithUnit('10px'), equals(new ParseResult<num>(10.0, 'px')));
      expect(parseNumWithUnit('10 px'), equals(new ParseResult<num>(10.0, 'px')));
      expect(parseNumWithUnit('10 px '), equals(new ParseResult<num>(10.0, 'px')));
      expect(parseNumWithUnit('10.px '), equals(new ParseResult<num>(10.0, 'px')));
      expect(parseNumWithUnit(' 10.0px '), equals(new ParseResult<num>(10.0, 'px')));

      expect(parseNumWithUnit('10.00. px ').isError, isFalse);

      expect(parseNumWithUnit('.0px '), equals(new ParseResult<num>(0.0, 'px')));

    });
  });

}
