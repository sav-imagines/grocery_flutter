import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorMessageComponent extends StatelessWidget {
  final String message;
  final String? title;
  const ErrorMessageComponent({super.key, required this.message, this.title});

  copyError() async {
    await Clipboard.setData(ClipboardData(text: message));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? "Error"),
      content: Text(message),
      // Padding(
      // padding: EdgeInsets.all(10),
      //   child: Text(message),
      // ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: copyError,
              icon: const Row(children: [Icon(Icons.copy), Text("Copy")]),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      ],
    );
  }
}
