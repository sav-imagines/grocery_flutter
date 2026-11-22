import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_flutter/components/show_confirmation.dart';
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
  GroupInfo? groupInfo = null;

  final controller = SocialController(jwt!);

  void getGroupInfo() async {
    final result = await controller.getOwnGroup();
    if (!mounted) return;
    if (result is RequestSuccess) {
      setState(() => groupInfo = (result as RequestSuccess).result);
    } else {
      showError(context, result as RequestError);
    }
  }

  void logout() async {
    await FlutterSecureStorage().delete(key: 'jwt');
    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).popAndPushNamed('/');
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
            onPressed: () {
              Navigator.of(context).pushNamed('/sent-invites');
            },
            icon: const Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed:
                () => showConfirmation(
                  context,
                  logout,
                  () => cancelAction(context),
                  "Are you sure you want to log out?",
                ),
            icon: const Icon(Icons.logout),
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
