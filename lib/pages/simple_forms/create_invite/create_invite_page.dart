import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/http/social/user_info.dart';
import 'package:grocery_flutter/pages/view/person_invite/person_invite_args.dart';
import 'package:grocery_flutter/components/person_card.dart';

class CreateInvitePage extends ConsumerStatefulWidget {
  const CreateInvitePage({super.key});

  @override
  ConsumerState<CreateInvitePage> createState() => _CreateInvitePageState();
}

class _CreateInvitePageState extends ConsumerState<CreateInvitePage> {
  // will NOT work if not initialized to null
  List<UserInfo>? foundUsers = null;
  final searchController = TextEditingController();
  String query = "";

  // searchUsers(String item) async {
  //   var users = await getUsersByName(item);
  //   if (!mounted) return;
  //   if (users is RequestError) {
  //     showError(context, users as RequestError);
  //   } else if (mounted) {
  //     setState(() {
  //       foundUsers = (users as RequestSuccess<List<UserInfo>>).result;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final foundUsers = ref.watch(getUsersByNameProvider(query));

    return Scaffold(
      appBar: AppBar(title: Text('Invite user')),
      body: switch (foundUsers) {
        AsyncData(:final value) when value.isEmpty => const Center(
          child: Text("No users were found with that query."),
        ),
        AsyncData(:final value) => Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    spacing: 10,
                    children:
                        value.map((e) {
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
              onSubmitted: (value) => setState(() => query = value),
              onEditingComplete:
                  () => setState(() {
                    query = searchController.text;
                  }),
              canRequestFocus: true,
            ),
          ],
        ),
        AsyncError(:final error) => ErrorWidget(error),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
