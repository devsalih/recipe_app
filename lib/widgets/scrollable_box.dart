import 'package:flutter/material.dart';

import 'scroll_to_top_button.dart';

class ScrollableBox extends StatelessWidget {
  final Color color;
  final ScrollController controller;
  final double offset;
  final List<Widget> children;
  final Widget? top, bottom, floatingActionButton;

  const ScrollableBox({
    Key? key,
    required this.controller,
    required this.children,
    required this.color,
    required this.offset,
    this.top,
    this.bottom,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom + 55;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  if (top != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: top!,
                    ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: children.length,
                      itemBuilder: (context, index) => children[index],
                    ),
                  ),
                  if (bottom != null)
                    Padding(padding: const EdgeInsets.all(20), child: bottom!),
                  const SizedBox(height: 6),
                ],
              ),
            ),
            if (offset > 0)
              Positioned(
                bottom: floatingActionButton != null ? 112 : 33,
                right: 40,
                child: ScrollToTopButton(
                  controller: controller,
                  color: color,
                  onPressed: scrollToTop,
                ),
              ),
            if (floatingActionButton != null)
              Positioned(bottom: 33, right: 40, child: floatingActionButton!),
          ],
        ),
      ),
    );
  }

  void scrollToTop() {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
