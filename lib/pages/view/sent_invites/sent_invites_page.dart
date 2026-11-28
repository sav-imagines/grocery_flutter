import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/components/invited_person_card.dart';

class SentInvitesPage extends ConsumerStatefulWidget {
  const SentInvitesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SentInvitesPageState();
}

class _SentInvitesPageState extends ConsumerState<SentInvitesPage> {
  var searchController = TextEditingController();

  // Future<void> refresh() async {
  //   final result = await controller.getSentInvites();
  //   if (!mounted) return;
  //   if (result is RequestSuccess<List<Invite>>) {
  //     setState(() => invites = result.result);
  //   } else {
  //     setState(() => invites = List.empty());
  //     showError(context, result as RequestError<List<Invite>>);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final invites = ref.watch(getSentInvitesProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/invite');
        },
      ),
      appBar: AppBar(title: Text('Sent invites')),
      body: RefreshIndicator(
        onRefresh: () async => await ref.refresh(getSentInvitesProvider.future),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: switch (invites) {
            AsyncData(:final value) => ListView(
              children: [
                Column(
                  spacing: 10,
                  children:
                      (value.isEmpty
                          ? const <Widget>[
                            Center(
                              child: Text("You haven't sent any invites yet"),
                            ),
                          ]
                          : value
                              .map(
                                (e) => InvitedPersonCard(
                                  invite: e,
                                  onRetract: () async {
                                    var result = await retractInvite(e);
                                    if (!context.mounted) return;
                                    if (result is RequestSuccess) {
                                      setState(() {
                                        value.remove(e);
                                      });
                                    } else {
                                      showError(
                                        context,
                                        (context as RequestError),
                                      );
                                    }
                                  },
                                ),
                              )
                              .toList()),
                ),
              ],
            ),
            AsyncError(:final error) => ErrorWidget(error),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}
