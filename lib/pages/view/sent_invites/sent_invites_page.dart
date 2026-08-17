import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/social/invite.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/components/invited_person_card.dart';
import 'package:grocery_flutter/state/global_state.dart';

class SentInvitesPage extends StatefulWidget {
  const SentInvitesPage({super.key});

  @override
  State<SentInvitesPage> createState() => _SentInvitesPageState();
}

class _SentInvitesPageState extends State<SentInvitesPage> {
  List<Invite>? invites = null;

  final searchController = TextEditingController();
  final SocialController controller = SocialController(jwt!);

  Future<void> refresh() async {
    final result = await controller.getSentInvites();
    if (!mounted) return;
    if (result is RequestSuccess<List<Invite>>) {
      setState(() => invites = result.result);
    } else {
      setState(() => invites = List.empty());
      showError(context, result as RequestError<List<Invite>>);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (invites == null) {
      refresh();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/invite');
        },
      ),
      appBar: AppBar(title: Text('Sent invites')),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Column(
                spacing: 10,
                children:
                    invites == null
                        ? <Widget>[
                          Center(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CircularProgressIndicator(),
                                  Text("Fetching response"),
                                ],
                              ),
                            ),
                          ),
                        ]
                        : (invites!.isEmpty
                            ? const <Widget>[
                              Center(
                                child: Text("You haven't sent any invites yet"),
                              ),
                            ]
                            : invites!
                                .map(
                                  (e) => InvitedPersonCard(
                                    invite: e,
                                    onRetract: () async {
                                      var result = await controller
                                          .retractInvite(e);
                                      if (!context.mounted) return;
                                      if (result is RequestSuccess) {
                                        setState(() {
                                          invites!.remove(e);
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
        ),
      ),
    );
  }
}
