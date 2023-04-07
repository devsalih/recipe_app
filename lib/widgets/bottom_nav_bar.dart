import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomTabBar extends StatelessWidget {
  final Color backgroundColor;
  final void Function(int) onPageChanged;

  const BottomTabBar({
    Key? key,
    required this.onPageChanged,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const icons = [
      FontAwesomeIcons.solidHeart,
      FontAwesomeIcons.utensils,
      FontAwesomeIcons.clockRotateLeft,
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 10,
            top: 10,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: IconButton(
                    onPressed: () => onPageChanged(index),
                    icon: Icon(icons[index], size: 30),
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
