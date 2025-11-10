import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/error_message_component.dart';

void showError(BuildContext context, String error, String? title) => showDialog(
  context: context,
  builder: (context) => ErrorMessageComponent(message: error, title: title),
);
