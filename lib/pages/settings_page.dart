import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/services/create_pdf.dart';
import 'package:share_plus/share_plus.dart';

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
  @override
  Widget build(BuildContext context) {
    var jwt = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FilledButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    content: const Text(
                      "Are you sure you want to leave your group?",
                    ),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      FilledButton(
                        onPressed: () async {
                          if (mounted) {
                            var controller = SocialController(jwt: jwt);
                            var result = await controller.leaveGroup();
                            if (result is RequestSuccess) {
                              Fluttertoast.showToast(msg: "Left your group");
                              if (context.mounted) {
                                // close popup
                                Navigator.of(context).pop();
                                // go back to home screen
                                Navigator.of(context).pop();
                                // swap home screen for invites screen automatically
                                Navigator.of(
                                  context,
                                ).popAndPushNamed("/redirect-group");
                              }
                            } else if (result is RequestError) {
                              Fluttertoast.showToast(
                                msg: "Failed because '${result.error}'",
                              );
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          }
                        },
                        child: const Text("Leave"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("Leave group"),
          ),
          FilledButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    content: const Text(
                      "Are you sure you want to delete your account?",
                    ),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("No"),
                      ),
                      FilledButton(
                        onPressed: () async {
                          // TODO: Implement account deletion
                          Fluttertoast.showToast(
                            msg: "You got me, that doesn't do anything yet.",
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("Yes, delete it"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("Delete account"),
          ),
          FilledButton(
            onPressed: () async {
              final pdf = createPdf();
              await SharePlus.instance.share(
                ShareParams(
                  files: [
                    XFile.fromData(
                      mimeType: "application/pdf",
                      await pdf.save(),
                    ),
                  ],
                  fileNameOverrides: ["Export.pdf"],
                ),
              );
            },
            child: const Text("Export PDF"),
          ),
        ],
      ),
    );
  }
}
