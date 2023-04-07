import 'package:flutter/material.dart';

class ColorUtils {
  static List<Color> generateShades(Color color) {
    return [
      Color.lerp(color, Colors.white, 1.0)!,
      Color.lerp(color, Colors.white, 0.5)!,
    ];
  }
}
