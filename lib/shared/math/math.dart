library bwu_utils.shared.math.math;

import 'dart:math' as math;

num nullSafeMax(num a, num b, {bool nullIsZero: false}) {
  if (nullIsZero && (a == null || b == null)) {
    num an = a != null ? a : 0;
    num bn = b != null ? b : 0;
    return math.max(an, bn);
  }
  if (a == null) {
    if (b == null) {
      return null;
    }
    return b;
  } else {
    if (b == null) {
      return a;
    }
  }
  return math.max(a, b);
}

num nullSafeMin(num a, num b, {bool nullIsZero: false}) {
  if (nullIsZero && (a == null || b == null)) {
    num an = a != null ? a : 0;
    num bn = b != null ? b : 0;
    return math.min(an, bn);
  }
  if (a == null) {
    if (b == null) {
      return null;
    }
    return b;
  } else {
    if (b == null) {
      return a;
    }
  }
  return math.min(a, b);
}
