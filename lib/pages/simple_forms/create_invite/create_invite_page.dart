import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/http/social/user_info.dart';
import 'package:grocery_flutter/pages/view/person_invite/person_invite_args.dart';
import 'package:grocery_flutter/components/person_card.dart';
import 'package:grocery_flutter/state/global_state.dart';

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
    if (!mounted) return;
    if (users is RequestError) {
      showError(context, users as RequestError);
    } else if (mounted) {
      setState(() {
        foundUsers = (users as RequestSuccess<List<UserInfo>>).result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SocialController controller = SocialController(jwt!);
    return Scaffold(
      appBar: AppBar(title: Text('Invite user')),
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
                                    arguments: PersonInviteArgs(person: e),
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
