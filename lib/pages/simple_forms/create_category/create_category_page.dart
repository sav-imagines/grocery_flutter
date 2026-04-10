import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/category/category_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/state/global_state.dart';

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
        Navigator.of(context).pop();
      } else if (result is RequestError) {
        showError(context, result);
      } else {
        throw Exception("Unreachable code reached");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController(jwt!);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('New category')),
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
