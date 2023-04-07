import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title, content;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    cancel() => Navigator.of(context).pop(false);
    delete() => Navigator.of(context).pop(true);

    const TextStyle titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    const TextStyle contentStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: titleStyle),
      content: Text(content, style: contentStyle),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          onPressed: cancel,
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: delete,
          child: const Text('REMOVE'),
        ),
      ],
    );
  }
}