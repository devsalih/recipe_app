import 'package:flutter/material.dart';

class EmptyRow extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final bool hasBackground;
  final VoidCallback? onTap;

  const EmptyRow({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.hasBackground = false, this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
    const subtitleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w300);

    BoxDecoration decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5),
      ],
    );

    return Container(
      decoration: hasBackground ? decoration : null,
      child: Opacity(
        opacity: 0.5,
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(title, style: titleStyle),
          subtitle: Text(subtitle, style: subtitleStyle),
        ),
      ),
    );
  }
}
