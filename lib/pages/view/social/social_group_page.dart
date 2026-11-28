import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_flutter/components/show_confirmation.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/components/person_card.dart';

class SocialGroupPage extends ConsumerWidget {
  const SocialGroupPage({super.key});

  logout(BuildContext context) => () async {
    await FlutterSecureStorage().delete(key: 'jwt');
    if (!context.mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).popAndPushNamed('/');
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupInfo = ref.watch(getOwnGroupProvider);
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
                  logout(context),
                  () => cancelAction(context),
                  "Are you sure you want to log out?",
                ),
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Text('Your group'),
      ),
      body: switch (groupInfo) {
        AsyncData(:final value) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: ListView(
            children: [
              Column(
                spacing: 10,
                children:
                    value.users
                        .map(
                          (user) => PersonCard(
                            userInfo: user,
                            onTap: () {},
                            isOwner: user.name == value.owner,
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
        AsyncError(:final error) => ErrorWidget(error),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
