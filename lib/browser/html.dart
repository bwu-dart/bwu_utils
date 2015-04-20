library bwu_utils.browser.html;

import 'dart:html' as dom;
import '../shared/math/parse_num.dart';

dom.HtmlElement getParentElement(dom.Node element) {
  if (element.parentNode == null) {
    return null;
  }
  if (element.parentNode is dom.ShadowRoot) {
    return (element.parentNode as dom.ShadowRoot).host;
  } else {
    return element.parentNode as dom.HtmlElement;
  }
}

int innerWidth(dom.HtmlElement e) {
  var cs = e.getComputedStyle();
  return parseIntDropUnit(cs.width) +
      parseIntDropUnit(cs.paddingLeft) +
      parseIntDropUnit(cs.paddingRight);
}

int innerHeight(dom.HtmlElement e) {
  var cs = e.getComputedStyle();
  return parseIntDropUnit(cs.height) +
      parseIntDropUnit(cs.paddingTop) +
      parseIntDropUnit(cs.paddingBottom);
}

int outerWidth(dom.HtmlElement e) {
  var cs = e.getComputedStyle();
  return parseIntDropUnit(cs.width) +
      parseIntDropUnit(cs.paddingLeft) +
      parseIntDropUnit(cs.paddingRight) +
      parseIntDropUnit(cs.borderLeftWidth) +
      parseIntDropUnit(cs.borderRightWidth);
}

int outerHeight(dom.HtmlElement e) {
  var cs = e.getComputedStyle();
  return parseIntDropUnit(cs.height) +
      parseIntDropUnit(cs.paddingTop) +
      parseIntDropUnit(cs.paddingBottom) +
      parseIntDropUnit(cs.borderTopWidth) +
      parseIntDropUnit(cs.borderBottomWidth);
}

dom.HtmlElement closest(dom.HtmlElement e, String selector,
    {dom.HtmlElement context, bool goThroughShadowBoundaries: false}) {
  dom.HtmlElement curr = e;

  if (context != null) {
    //print('tools.closest: context not yet supported: ${context}');
  }

  dom.Node p = curr.parentNode;
  if (p is dom.ShadowRoot) {
    p = (p as dom.ShadowRoot).host;
  }

  dom.HtmlElement parent = (p as dom.HtmlElement);

  var prevParent = e;
  var found;
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

    if (parent is dom.ShadowRoot) {
      if (goThroughShadowBoundaries) {
        parent = (parent as dom.ShadowRoot).host;
      }
    } else {
      parent = parent.parent;
    }
  }

  return found;
}
