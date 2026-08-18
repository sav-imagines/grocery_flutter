import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/show_confirmation.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/http/category/category_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/pages/complex_forms/edit_category/edit_category_args.dart';
import 'package:grocery_flutter/state/global_state.dart';

class EditCategoryPage extends StatefulWidget {
  const EditCategoryPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EditCategoryPageState();
  }
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  EditCategoryArgs? args;

  void delete() async {
    assert(args != null);
    final result = await CategoryController(
      jwt!,
    ).deleteCategory(args!.category.id);
    if (!mounted) return;
    if (result is RequestSuccess) {
      args!.state.items.removeWhere((cat) => cat.id == args!.category.id);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      showError(context, result as RequestError);
    }
  }

  @override
  Widget build(BuildContext context) {
    args ??= ModalRoute.of(context)!.settings.arguments as EditCategoryArgs;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit category"),
        actions: [
          IconButton(
            onPressed:
                () => showConfirmation(
                  context,
                  delete,
                  () => cancelAction(context),
                  "Are you sure you want to delete category ${args!.category.name}?",
                ),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
