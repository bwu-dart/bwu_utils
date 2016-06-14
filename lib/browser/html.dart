library bwu_utils.browser.html;

import 'dart:html' show CssStyleDeclaration, HtmlElement, Node, ShadowRoot;
import '../shared/math/parse_num.dart';

HtmlElement getParentElement(Node element) {
  if (element.parentNode == null) {
    return null;
  }
  if (element.parentNode is ShadowRoot) {
    return (element.parentNode as ShadowRoot).host;
  } else {
    return element.parentNode as HtmlElement;
  }
}

int innerWidth(HtmlElement e) {
  final CssStyleDeclaration cs = e.getComputedStyle();
  return parseIntDropUnit(cs.width) +
      parseIntDropUnit(cs.paddingLeft) +
      parseIntDropUnit(cs.paddingRight);
}

int innerHeight(HtmlElement e) {
  final CssStyleDeclaration cs = e.getComputedStyle();
  return parseIntDropUnit(cs.height) +
      parseIntDropUnit(cs.paddingTop) +
      parseIntDropUnit(cs.paddingBottom);
}

int outerWidth(HtmlElement e) {
  final CssStyleDeclaration cs = e.getComputedStyle();
  return parseIntDropUnit(cs.width) +
      parseIntDropUnit(cs.paddingLeft) +
      parseIntDropUnit(cs.paddingRight) +
      parseIntDropUnit(cs.borderLeftWidth) +
      parseIntDropUnit(cs.borderRightWidth);
}

int outerHeight(HtmlElement e) {
  final CssStyleDeclaration cs = e.getComputedStyle();
  return parseIntDropUnit(cs.height) +
      parseIntDropUnit(cs.paddingTop) +
      parseIntDropUnit(cs.paddingBottom) +
      parseIntDropUnit(cs.borderTopWidth) +
      parseIntDropUnit(cs.borderBottomWidth);
}

HtmlElement closest(HtmlElement e, String selector,
    {HtmlElement context, bool goThroughShadowBoundaries: false}) {
  HtmlElement curr = e;

  if (context != null) {
    //print('tools.closest: context not yet supported: ${context}');
  }

  Node p = curr.parentNode;
  if (p is ShadowRoot) {
    p = (p as ShadowRoot).host;
  }

  HtmlElement parent = (p as HtmlElement);

  HtmlElement prevParent = e;
  HtmlElement found;
  while (parent != null && found == null) {
    found = parent.querySelector(selector);
    if (found != null) {
      if (parent.querySelectorAll(selector).contains(prevParent)) {
        return prevParent;
      } else {
        return found;
      }
    } else {
      if (parent.querySelectorAll(selector).contains(prevParent)) {
        return prevParent;
      }
    }
    prevParent = parent;

    if (parent is ShadowRoot) {
      if (goThroughShadowBoundaries) {
        parent = (parent as ShadowRoot).host;
      }
    } else {
      parent = parent.parent;
    }
  }

  return found;
}
