import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/show_confirmation.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/state/global_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final controller = SocialController(jwt!);

  deleteAccount() {
    // TODO: Implement account deletion
    Fluttertoast.showToast(msg: "You got me, that doesn't do anything yet.");
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  leaveGroup() async {
    if (mounted) {
      var result = await controller.leaveGroup();
      if (result is RequestSuccess) {
        Fluttertoast.showToast(msg: "Left your group");
        if (!mounted) return;
        // close popup
        Navigator.of(context).pop();
        // go back to home screen
        Navigator.of(context).pop();
        // swap home screen for invites screen automatically
        Navigator.of(context).popAndPushNamed("/redirect-group");
      } else if (result is RequestError) {
        Fluttertoast.showToast(msg: "Failed because '${result.error}'");
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  leaveGroup,
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
                  deleteAccount,
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
