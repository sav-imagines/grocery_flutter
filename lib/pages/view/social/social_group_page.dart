import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_flutter/http/social/group_info.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/pages/view/sent_invites_page/sent_invites_args.dart';
import 'package:grocery_flutter/components/person_card.dart';

class SocialGroupPage extends StatefulWidget {
  const SocialGroupPage({super.key});

  @override
  State<SocialGroupPage> createState() => _SocialGroupPageState();
}

class _SocialGroupPageState extends State<SocialGroupPage> {
  late GroupInfo? groupInfo = null;

  @override
  Widget build(BuildContext context) {
    var jwt = ModalRoute.of(context)!.settings.arguments as String;
    SocialController controller = SocialController(jwt: jwt);
    if (groupInfo == null) {
      controller.getOwnGroup().then(
        (value) {
          if (mounted) {
            setState(() {
              groupInfo = value;
            });
          }
        },
        onError: (error) {
          throw Exception(error);
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamed(
                '/sent-invites',
                arguments: SentInvitesArgs(jwt: jwt, isInGroup: true),
              );
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/settings', arguments: jwt);
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

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/invite', arguments: jwt);
        },
      ),
    );
  }
}
