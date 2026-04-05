import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/social/invite.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/components/invite_card.dart';

class ReceivedInvitesPage extends StatefulWidget {
  const ReceivedInvitesPage({super.key});

  @override
  State<ReceivedInvitesPage> createState() => _ReceivedInvitesPageState();
}

class _ReceivedInvitesPageState extends State<ReceivedInvitesPage> {
  // will NOT work if not initialized to null
  late List<Invite>? invites = null;
  final searchController = TextEditingController();

  Future<void> refresh(SocialController controller) async {
    final value = await controller.getMyInvites();
    setState(() {
      invites = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final jwt = ModalRoute.of(context)!.settings.arguments as String;
    final SocialController controller = SocialController(jwt: jwt);
    if (invites == null) {
      refresh(controller);
    }
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
        onRefresh:
            () => Future.delayed(
              Duration(milliseconds: 200),
              () => refresh(controller),
            ),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Column(
              spacing: 20,
              children:
                  invites == null || invites!.isEmpty
                      ? <Widget>[
                        Center(
                          child: Center(
                            child: Text(
                              "You haven't been invited to any groups.",
                            ),
                          ),
                        ),
                      ]
                      : invites!
                          .map(
                            (e) => InviteCard(
                              invite: e,
                              onAccept: () async {
                                var result = await controller.acceptInvite(e);
                                if (result is RequestSuccess) {
                                  Fluttertoast.showToast(msg: 'Succes :D');
                                  if (context.mounted) {
                                    Navigator.of(
                                      context,
                                    ).popAndPushNamed('/redirect-group');
                                  }
                                } else if (result is RequestError) {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Error type: ${result.errorType()}, Error: ${result.error}',
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'Something went horribly wrong here',
                                  );
                                  throw Exception("Impossible state occurred");
                                }
                                return;
                              },
                              onReject: () async {
                                var result = await controller.rejectInvite(e);
                                if (result is RequestSuccess) {
                                  Fluttertoast.showToast(msg: 'Succes :D');
                                  setState(() {
                                    invites!.remove(e);
                                  });
                                } else if (result is RequestError) {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Error type: ${result.errorType()}, Error: ${result.error}',
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'Something went horribly wrong here',
                                  );
                                  throw Exception("Impossible state occurred");
                                }

                                return;
                              },
                            ),
                          )
                          .toList(),
            ),
            invites == null || invites!.isEmpty
                ? SizedBox.shrink()
                : SizedBox.square(dimension: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamed('/create-group', arguments: jwt);
                },
                child: const Text("Create a group"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
