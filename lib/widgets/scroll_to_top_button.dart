import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScrollToTopButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ScrollController controller;
  final Color color;

  const ScrollToTopButton({
    Key? key,
    required this.onPressed,
    required this.controller,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: max(min(controller.scrollPercentage * 4, 1), 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CustomPaint(
          painter: MyPainter(controller, color),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.anglesUp),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final ScrollController controller;
  final Color color;

  MyPainter(this.controller, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double degrees = controller.scrollPercentage * 360;
    degrees = controller.isAtTheEnd ? 359.99 : degrees;

    final Paint paint = Paint()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = color;

    double degToRad(double deg) => deg * (pi / 180.0);

    final path = Path()
      ..arcTo(
          Rect.fromCenter(
            center: Offset(size.height / 2, size.width / 2),
            height: size.height - 5,
            width: size.width - 5,
          ),
          degToRad(-90),
          degToRad(degrees),
          false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

extension ScrollControllerExtension on ScrollController {
  double get scrollPercentage => offset / position.maxScrollExtent;
  bool get isAtTheEnd => offset >= position.maxScrollExtent;
}
