import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/search_model.dart';
import '../utils/string_utils.dart';

class SearchRow extends StatelessWidget {
  final Widget? trailing;
  final Search search;

  const SearchRow({
    Key? key,
    required this.search,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
    const subtitleStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w300);

    const duration = Duration(milliseconds: 300);
    Widget dismissButton = AnimatedOpacity(
      duration: duration,
      opacity: trailing != null ? 1 : 0,
      child: AnimatedContainer(
        duration: duration,
        width: trailing != null ? 50 : 0,
        child: trailing,
      ),
    );

    return CupertinoListTile(
        title: Text(search.query, style: titleStyle, maxLines: 2),
        subtitle: Text(StringUtils.filters(search), style: subtitleStyle),
        trailing: dismissButton,
        leadingSize: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(FontAwesomeIcons.clockRotateLeft, color: Colors.white),
        ));
  }
}
