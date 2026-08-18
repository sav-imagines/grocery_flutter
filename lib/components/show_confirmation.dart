import 'package:flutter/material.dart';

void showConfirmation(
  BuildContext context,
  Function()? onAccept,
  Function()? onCancel,
  String title, {
  String acceptText = "Accept",
  String cancelText = "Cancel",
}) {
  if (!context.mounted) return;
  showDialog(
    context: context,
    builder:
        (BuildContext ctx) => AlertDialog(
          content: Text(title, style: Theme.of(context).textTheme.titleLarge),
          actions: [
            FilledButton(onPressed: onCancel, child: Text(cancelText)),
            FilledButton.tonal(onPressed: onAccept, child: Text(acceptText)),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        ),
  );
}

void cancelAction(BuildContext context) {
  Navigator.of(context).pop();
}
