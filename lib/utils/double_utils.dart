import 'dart:math';

class DoubleUtils {
  static double zeroToOne(double value,
      {double start = 0, double multiplier = 1, required double end}) {
    return min(max((value - start) / (end - start), 0), 1) * multiplier;
  }

  static double oneToZero(double value,
      {double start = 0, double multiplier = 1, required double end}) {
    return multiplier -
        zeroToOne(value, start: start, multiplier: multiplier, end: end);
  }
}
