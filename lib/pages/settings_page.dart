import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/show_confirmation.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  deleteAccount(BuildContext context) => () {
    Fluttertoast.showToast(msg: "You got me, that doesn't do anything yet.");
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  };

  attemptLeaveGroup(BuildContext context) => () async {
    if (context.mounted) {
      var result = await leaveGroup();
      if (result is RequestSuccess) {
        Fluttertoast.showToast(msg: "Left your group");
        if (!context.mounted) return;
        // close popup
        Navigator.of(context).pop();
        // go back to home screen
        Navigator.of(context).pop();
        // swap home screen for invites screen automatically
        Navigator.of(context).popAndPushNamed("/redirect-group");
      } else if (result is RequestError) {
        Fluttertoast.showToast(msg: "Failed because '${result.error}'");
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            onTap:
                () => showConfirmation(
                  context,
                  attemptLeaveGroup(context),
                  () => cancelAction(context),
                  "Are you sure you want to leave your group?",
                ),
            title: const Text("Leave group"),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
          ),
          ListTile(
            onTap:
                () => showConfirmation(
                  context,
                  deleteAccount(context),
                  () => cancelAction(context),
                  "Are you sure you want to delete your account? This action cannot be undone!",
                ),
            title: const Text("Delete account"),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
