import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/components/invite_card.dart';

class ReceivedInvitesPage extends ConsumerStatefulWidget {
  const ReceivedInvitesPage({super.key});

  @override
  ConsumerState<ReceivedInvitesPage> createState() =>
      _ReceivedInvitesPageState();
}

class _ReceivedInvitesPageState extends ConsumerState<ReceivedInvitesPage> {
  final searchController = TextEditingController();

  // Future<void> refresh() async {
  //   final value = await socialController.getMyInvites();
  //   if (value is RequestSuccess<List<Invite>>)
  //     setState(() {
  //       invites = value.result;
  //     });
  //   else {
  //     if (mounted) showError(context, (value as RequestError));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final invites = ref.watch(getMyInvitesProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FlutterSecureStorage().delete(key: 'jwt');
              if (context.mounted) Navigator.of(context).popAndPushNamed('/');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(getMyInvitesProvider.future),
        child: switch (invites) {
          AsyncData(:final value) when value.isEmpty => Center(
            child: Center(
              child: Text("You haven't been invited to any groups."),
            ),
          ),
          AsyncData(:final value) => ListView(
            padding: EdgeInsets.all(10),
            children: [
              Column(
                spacing: 20,
                children:
                    value
                        .map(
                          (e) => InviteCard(
                            invite: e,
                            onAccept: () async {
                              var result = await acceptInvite(e);
                              if (!context.mounted) return;
                              if (result is RequestSuccess) {
                                if (context.mounted) {
                                  Navigator.of(
                                    context,
                                  ).popAndPushNamed('/redirect-group');
                                }
                              } else {
                                showError(context, result as RequestError);
                              }
                            },
                            onReject: () async {
                              var result = await rejectInvite(e);
                              if (!context.mounted) return;
                              if (result is RequestSuccess) {
                                setState(() {
                                  value.remove(e);
                                });
                              } else {
                                showError(context, result as RequestError);
                              }
                            },
                          ),
                        )
                        .toList(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/create-group');
                  },
                  child: const Text("Create a group"),
                ),
              ),
            ],
          ),
          AsyncError(:final error) => ErrorWidget(error),
          AsyncLoading() => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
