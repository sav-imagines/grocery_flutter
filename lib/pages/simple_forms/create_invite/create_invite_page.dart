import 'package:flutter/material.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/http/social/user_info.dart';
import 'package:grocery_flutter/pages/view/person_invite/person_invite_args.dart';
import 'package:grocery_flutter/components/person_card.dart';

class CreateInvitePage extends StatefulWidget {
  const CreateInvitePage({super.key});

  @override
  State<CreateInvitePage> createState() => _CreateInvitePageState();
}

class _CreateInvitePageState extends State<CreateInvitePage> {
  // will NOT work if not initialized to null
  late List<UserInfo>? foundUsers = null;
  final searchController = TextEditingController();

  searchUsers(String item, SocialController controller) async {
    var users = await controller.getUsersByName(item);
    if (users == null) return;
    if (mounted) {
      setState(() {
        foundUsers = users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var jwt = ModalRoute.of(context)!.settings.arguments as String;
    SocialController controller = SocialController(jwt: jwt);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Invite user'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  foundUsers == null
                      ? Text('')
                      : Column(
                        spacing: 10,
                        children:
                            foundUsers!.map((e) {
                              return PersonCard(
                                userInfo: e,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/invite-person',
                                    arguments: PersonInviteArgs(
                                      jwt: jwt,
                                      person: e,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),
                ],
              ),
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                label: Text('Search'),
                hintText: 'username',
                prefixIcon: Icon(Icons.search),
              ),
              controller: searchController,
              onSubmitted: (value) => searchUsers(value, controller),
              onEditingComplete:
                  () => searchUsers(searchController.text, controller),
              canRequestFocus: true,
            ),
          ],
        ),
      ),
    );
  }
}
