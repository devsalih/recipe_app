import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Widget? trailing;

  const PageTitle({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
    const subtitleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w300);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.black),
        title: Text(title, style: titleStyle),
        subtitle: Text(subtitle, style: subtitleStyle),
        trailing: trailing,
      ),
    );
  }
}
