import 'package:flutter/material.dart';

import '../utils/double_utils.dart';

class AppBarAnimation extends StatelessWidget {
  final double offset;
  final Widget child;

  const AppBarAnimation({
    Key? key,
    required this.offset,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        0,
        DoubleUtils.oneToZero(offset, start: 280, end: 320, multiplier: 40),
      ),
      child: Opacity(
        opacity: DoubleUtils.zeroToOne(offset, start: 270, end: 310),
        child: child,
      ),
    );
  }
}
