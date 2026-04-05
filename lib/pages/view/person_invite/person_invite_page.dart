import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/http/social/user_info.dart';
import 'package:grocery_flutter/pages/view/person_invite/person_invite_args.dart';

class PersonInvitePage extends StatefulWidget {
  const PersonInvitePage({super.key});

  @override
  State<PersonInvitePage> createState() => _PersonInvitePageState();
}

class _PersonInvitePageState extends State<PersonInvitePage> {
  late bool? isInvited = null;
  static String getDescription(Duration timeDelta) {
    if (timeDelta.inDays > 365) {
      return '${(timeDelta.inDays / 365).floor()} year${(timeDelta.inDays / 365).floor() > 1 ? "s" : ""} ago';
    } else if (timeDelta.inDays > 0) {
      return '${timeDelta.inDays} day${timeDelta.inDays > 1 ? "s" : ""} ago';
    } else if (timeDelta.inHours > 0) {
      return '${timeDelta.inHours} hour${timeDelta.inHours > 1 ? "s" : ""} ago';
    } else if (timeDelta.inMinutes > 0) {
      return '${timeDelta.inMinutes} minute${timeDelta.inMinutes > 1 ? "s" : ""} ago';
    } else {
      return '${timeDelta.inSeconds} second${timeDelta.inSeconds > 1 ? "s" : ""} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PersonInviteArgs;
    var person = args.person;
    SocialController controller = SocialController(jwt: args.jwt);
    if (isInvited == null) {
      controller
          .isInvited(person.id)
          .then(
            (result) => {
              if (result is RequestSuccess<bool>)
                {
                  setState(() {
                    isInvited = result.result;
                  }),
                }
              else if (result is RequestError<bool>)
                {
                  Fluttertoast.showToast(
                    msg:
                        result.error.isEmpty
                            ? result.errorType()
                            : result.error,
                  ),
                },
            },
          );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("View user")),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.person, size: 100),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    person.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Joined ${getDescription(DateTime.now().difference(person.joinedAt))}',
                    ),
                  ),
                ],
              ),
            ],
          ),
          person.isInGroup
              ? FilledButton(
                onPressed: null,
                child: Text("Person is already in a group."),
              )
              : isInvited == null
              ? CircularProgressIndicator()
              : (isInvited!
                  ? FilledButton(
                    onPressed: null,
                    style: Theme.of(context).filledButtonTheme.style,
                    child: const Text("Person was invited"),
                  )
                  : FilledButton(
                    onPressed: () async {
                      var result = await controller.inviteUser(person.id);
                      if (result is RequestSuccess) {
                        setState(() {
                          person = UserInfo(
                            id: person.id,
                            name: person.name,
                            joinedAt: person.joinedAt,
                            isInGroup: true,
                          );
                          isInvited = true;
                        });
                      } else if (result is RequestError) {
                        Fluttertoast.showToast(msg: result.error);
                      }
                    },
                    child: const Text("Invite"),
                  )),
        ],
      ),
    );
  }
}
