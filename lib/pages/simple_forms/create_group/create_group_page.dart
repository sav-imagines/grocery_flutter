import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';
import 'package:grocery_flutter/state/global_state.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController groupNameController = TextEditingController();

  isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  submitGroup(SocialController controller) async {
    var result = await controller.createGroup(groupNameController.text);
    if (mounted) {
      if (result is RequestSuccess) {
        Fluttertoast.showToast(msg: "Created a group successfully");
        Navigator.of(context).pop();
      } else if (result is RequestError) {
        if (mounted) showError(context, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = SocialController(jwt!);
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
              onPressed: () => submitGroup(controller),
              child: Text('Create'),
            ),
            SizedBox.square(dimension: 40),
          ],
        ),
      ),
    );
  }
}
