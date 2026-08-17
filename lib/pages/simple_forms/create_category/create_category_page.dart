import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/category/category_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';
import 'package:grocery_flutter/state/global_state.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateCategoryPage> {
  TextEditingController categoryNameController = TextEditingController();

  final categoryController = CategoryController(jwt!);

  isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  void submitItem(
    CategoryController controller,
    String categoryName,
    CreateListArgs? oldState,
  ) async {
    var result = await controller.createCategory(categoryName);
    if (mounted) {
      if (result is RequestSuccess<String>) {
        List<CategoryModel> models = oldState?.items ?? [];
        models.add(
          CategoryModel(id: result.result, name: categoryName, items: []),
        );
        Navigator.of(context).pop();
        Navigator.of(
          context,
        ).popAndPushNamed('/create-list', arguments: oldState);
      } else if (result is RequestError) {
        showError(context, result as RequestError);
      } else {
        throw Exception("Unreachable code reached");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CreateListArgs? oldState =
        ModalRoute.of(context)?.settings.arguments as CreateListArgs?;
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
                  () => submitItem(
                    categoryController,
                    categoryNameController.text,
                    oldState,
                  ),
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
