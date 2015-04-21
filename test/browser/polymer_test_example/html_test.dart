//@Timeout(const Duration(minutes: 10))
@TestOn('browser')
library bwu_utils.test.shared.parse_num;

import 'dart:async' show Completer, Future, Stream;
import 'dart:html' as dom;
import 'package:polymer/polymer.dart';
import 'package:bwu_utils/testing_browser.dart';
import 'package:bwu_utils/bwu_utils_browser.dart';

final _log = new Logger('bwu_utils.test.shared.test_parse_num');

main() {
  initLogging();
  Completer polymerInitCompleter = new Completer();
  initPolymer().then((zone) => zone.run(() {
    Polymer.onReady.then((_) => polymerInitCompleter.complete());
  }));

  group('getParentElement', () {
    setUp(() {
      return polymerInitCompleter.future;
    });

    test('simple DOM elements', () {
      // set up
      final elem = dom.document.querySelector('#child');

      // exercise
      final parent = getParentElement(getParentElement(elem));

      // verification
      expect(parent, equals(dom.document.querySelector('#parent')));

      // tear down
    });

    test('Polymer elements', () {
      // set up
      final elem = dom.document.querySelector('#polymer-child');

      // exercise
      final parent = getParentElement(elem);
      final expectedParent = dom.document.querySelector('#polymer-parent');
      expect(expectedParent, isNotNull);

      // verification
      expect(parent, equals(expectedParent));

      // tear down
    });

    test('Polymer shadow DOM elements', () {
      // set up
      final elem = dom.document.querySelector('* /deep/ #shadow-dom-child');
      expect(elem, isNotNull);
      // exercise
      final parent = getParentElement(elem);
      final expectedParent = dom.document.querySelector('#polymer-parent');
      expect(expectedParent, isNotNull);

      // verification
      expect(parent, equals(expectedParent));

      // tear down
    }/*, timeout: const Timeout(const Duration(minutes: 3))*/);
  });
}
