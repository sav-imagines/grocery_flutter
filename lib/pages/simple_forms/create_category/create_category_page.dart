import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/category/category_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateCategoryPage> {
  TextEditingController categoryNameController = TextEditingController();
  isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  submitItem(CategoryController controller, String categoryName) async {
    final result = await controller.createCategory(categoryName);
    if (mounted) {
      if (result is RequestSuccess) {
        Fluttertoast.showToast(msg: "Success :D");
        Navigator.of(context).pop();
      } else if (result is RequestError) {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg:
              result.error.isEmpty
                  ? 'Error: ${result.errorType()}'
                  : result.error,
        );
      } else {
        throw Exception("Unreachable code reached");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final jwt = ModalRoute.of(context)!.settings.arguments as String;
    final controller = CategoryController(jwt: jwt);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('New category'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 150, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Enter a name:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            TextFormField(
              enableSuggestions: false,
              controller: categoryNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Item name",
              ),
              validator: (value) => isEmptyValidator(value),
            ),
            FilledButton(
              onPressed:
                  () => submitItem(controller, categoryNameController.text),
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
