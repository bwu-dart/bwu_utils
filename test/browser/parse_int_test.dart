library bwu_utils.test.browser.parse_int;

//import 'package:unittest/unittest.dart';
//import 'package:unittest/html_config.dart' show useHtmlConfiguration;
import 'package:bwu_utils/testing_browser.dart';

void main() {
//  useHtmlConfiguration();
  initLogging();
  group('parseInt', () {
    test('simple int', () {
      expect(parseIntDropUnit('0'), equals(0));
      expect(parseIntDropUnit('1'), equals(1));
      expect(parseIntDropUnit(' 1'), equals(1));
      expect(parseIntDropUnit('184'), equals(184));
    });

    test('with dimensions', () {
      expect(parseIntDropUnit('10px'), equals(10));
      expect(parseIntDropUnit('10%'), equals(10));
    });

    test('with double value', () {
      expect(parseIntDropUnit('184.984375'), equals(185));
    });
  });
}
