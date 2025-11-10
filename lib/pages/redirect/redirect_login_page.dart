import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';

class RedirectLoginPage extends StatefulWidget {
  const RedirectLoginPage({super.key});
  @override
  State<RedirectLoginPage> createState() => _RedirectLoginPageState();
}

class _RedirectLoginPageState extends State<RedirectLoginPage> {
  static const storage = FlutterSecureStorage();
  String statusMsg = "Loading JWT...";

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
          Text(statusMsg),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final savedJwt = await storage.read(key: 'jwt');
    if (savedJwt == null) {
      if (mounted) {
        Navigator.of(context).popAndPushNamed('/login');
      }
    } else {
      setState(() {
        statusMsg = "Validating JWT...";
      });
      final RequestResult<void> result = await AuthController.isValidToken(
        savedJwt,
      ).timeout(
        Duration(seconds: 7),
        onTimeout:
            () => Future.value(
              RequestErrorConnectionError<void>(
                "timed out while trying to validate token",
              ),
            ),
      );
      if (!mounted) return;
      if (result is RequestSuccess) {
        Navigator.of(
          context,
        ).popAndPushNamed('/redirect-group', arguments: savedJwt);
      } else if (result is RequestErrorConnectionError) {
        showError(context, result.error, "Connection error");
        if (mounted) {
          Navigator.of(context).popAndPushNamed('/login');
        }
      } else if (result is RequestError) {
        storage.delete(key: 'jwt');
        showError(context, result.error, "Request error");
        if (mounted) {
          Navigator.of(context).popAndPushNamed('/login');
        }
      } else {
        showError(
          context,
          "Unexpected type ${result.runtimeType}",
          "Programming error",
        );
      }
    }
  }
}
