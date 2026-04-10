import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/http/social/user_info.dart';

// redirects you based on whether you are in a group
class RedirectGroupPage extends StatefulWidget {
  const RedirectGroupPage({super.key});

  @override
  State<RedirectGroupPage> createState() => _RedirectGroupPageState();
}

class _RedirectGroupPageState extends State<RedirectGroupPage> {
  _RedirectGroupPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
          SizedBox.square(dimension: 10),
          const Text("Fetching group info..."),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkGroupStatus();
  }

  Future<void> checkGroupStatus() async {
    var jwt = await FlutterSecureStorage().read(key: 'jwt');
    if (jwt == null) {
      if (mounted)
        showErrorMessage(
          context,
          "JWT from storage was null",
          "Programming error",
        );
    } else {
      var controller = SocialController(jwt);
      RequestResult<UserInfo?> info = await controller.getMyInfo();
      if (info is RequestSuccess) {
        info = info as RequestSuccess<UserInfo>;
        if (info.result.isInGroup) {
          if (mounted) {
            Navigator.of(context).popAndPushNamed('/home');
          }
        } else {
          if (mounted) {
            Navigator.of(context).popAndPushNamed('/received-invites');
          }
        }
      }
    }
  }
}
