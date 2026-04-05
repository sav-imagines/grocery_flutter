import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_flutter/components/error_message_component.dart';
import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/auth/login_model.dart';
import 'package:grocery_flutter/http/social/request_result.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Login page')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 150, horizontal: 20),
        child: Form(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                    validator: (value) => isEmptyValidator(value),
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                  child: TextFormField(
                    enableSuggestions: false,
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                    validator: (value) => isEmptyValidator(value),
                  ),
                ),
              ),

              FilledButton(
                onPressed: () async {
                  RequestResult<String> response = await AuthController.login(
                    LoginModel(
                      userName: emailController.text,
                      password: passwordController.text,
                    ),
                  );
                  if (!context.mounted) return;
                  if (response is RequestSuccess<String>) {
                    storage.write(key: 'jwt', value: response.result);
                    Navigator.of(
                      context,
                    ).popAndPushNamed('/redirect-group', arguments: response);
                  } else if (response is RequestError<String>) {
                    showDialog(
                      context: context,
                      builder:
                          (ctx) =>
                              ErrorMessageComponent(message: response.error),
                    );
                  } else {
                    throw Exception("Code should be unreachable: $response");
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/create-account');
                },
                child: const Text('Create account'),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (ctx) => ErrorMessageComponent(message: "Test message"),
                  );
                },
                child: const Text('Test button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
