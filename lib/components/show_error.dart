import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/error_message_component.dart';
import 'package:grocery_flutter/http/social/request_result.dart';

void showErrorMessage(BuildContext context, String error, String? title) =>
    showDialog(
      context: context,
      builder: (context) => ErrorMessageComponent(message: error, title: title),
    );

void showError<T>(BuildContext context, RequestError<T> error) => showDialog(
  context: context,
  builder:
      (context) => ErrorMessageComponent(
        message: error.toString(),
        title: error.errorType(),
      ),
);
