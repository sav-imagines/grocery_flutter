import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/social/group_info.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/components/person_card.dart';
import 'package:grocery_flutter/state/global_state.dart';

class SocialGroupPage extends StatefulWidget {
  const SocialGroupPage({super.key});

  @override
  State<SocialGroupPage> createState() => _SocialGroupPageState();
}

class _SocialGroupPageState extends State<SocialGroupPage> {
  bool startedFetching = false;
  late GroupInfo? groupInfo = null;

  void getGroupInfo() async {
    final controller = SocialController(jwt!);
    final result = await controller.getOwnGroup();
    if (!mounted) return;
    if (result is RequestSuccess) {
      setState(() => groupInfo = (result as RequestSuccess).result);
    } else {
      showError(context, result as RequestError);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!startedFetching) {
      setState(() {
        startedFetching = true;
      });
      getGroupInfo();
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamed('/sent-invites');
            },
            icon: Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    content: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Are you sure you want to log out?"),
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
                          await FlutterSecureStorage().delete(key: 'jwt');
                          if (ctx.mounted) {
                            Navigator.of(ctx).pop();
                            Navigator.of(ctx).popAndPushNamed('/');
                          }
                        },
                        child: const Text("Log out"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: const Text('Your group'),
      ),
      body:
          groupInfo == null
              ? Center(child: const CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: ListView(
                  children: [
                    Column(
                      spacing: 10,
                      children:
                          groupInfo!.users
                              .map(
                                (user) => PersonCard(
                                  userInfo: user,
                                  onTap: () {},
                                  isOwner: user.name == groupInfo!.owner,
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
    );
  }
}
