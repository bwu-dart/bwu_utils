library bwu_utils.test.browser.parse_int;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart' show useHtmlConfiguration;
import 'package:bwu_utils/browser/html.dart' as tools;

void main() {
  useHtmlConfiguration();

  group('parseInt', () {
    test('simple int', () {
      expect(tools.parseIntFromStringWithUnit('0'), equals(0));
      expect(tools.parseIntFromStringWithUnit('1'), equals(1));
      expect(tools.parseIntFromStringWithUnit(' 1'), equals(1));
      expect(tools.parseIntFromStringWithUnit('184'), equals(184));
    });

    test('with dimensions', () {
      expect(tools.parseIntFromStringWithUnit('10px'), equals(10));
      expect(tools.parseIntFromStringWithUnit('10%'), equals(10));
    });

    test('with double value', () {
      expect(tools.parseIntFromStringWithUnit('184.984375'), equals(185));
    });
  });
}
