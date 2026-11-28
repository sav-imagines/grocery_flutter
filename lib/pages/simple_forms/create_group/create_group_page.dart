import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';

class CreateGroupPage extends ConsumerWidget {
  final TextEditingController groupNameController = TextEditingController();

  CreateGroupPage({super.key});

  isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  void submitGroup(BuildContext context) async {
    var result = await createGroup(groupNameController.text);
    if (context.mounted) {
      if (result is RequestSuccess) {
        Fluttertoast.showToast(msg: "Created a group successfully");
        Navigator.of(context).pop();
        Navigator.of(context).popAndPushNamed('/redirect-group');
      } else if (result is RequestError) {
        if (context.mounted) showError(context, result);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('New group')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Row(
              children: [
                Text(
                  'Enter a group name',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            TextFormField(
              enableSuggestions: false,
              controller: groupNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Group name",
              ),
              validator: (value) => isEmptyValidator(value),
            ),
            FilledButton(
              onPressed: () => submitGroup(context),
              child: Text('Create'),
            ),
            SizedBox.square(dimension: 40),
          ],
        ),
      ),
    );
  }
}
