import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/item/create_item_model.dart';
import 'package:grocery_flutter/http/item/item_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/pages/simple_forms/create_list_item/create_list_item_args.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';
import 'package:grocery_flutter/models/short_item.dart';

class CreateRecipeItemPage extends StatefulWidget {
  const CreateRecipeItemPage({super.key});

  @override
  State<CreateRecipeItemPage> createState() => _CreateRecipeItemPageState();
}

class _CreateRecipeItemPageState extends State<CreateRecipeItemPage> {
  TextEditingController itemNameController = TextEditingController();
  isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  submitItem(
    ItemController controller,
    CreateItemModel item,
    CreateItemArgs args,
  ) async {
    var result = await controller.createItem(item);
    if (mounted) {
      if (result is RequestSuccess<String>) {
        args.items!
            .firstWhere((category) => category.id == item.categoryId)
            .items
            .add(ShortItem(id: result.result, name: item.name, quantity: 1));
        Navigator.of(context).pop();
        Navigator.of(context).popAndPushNamed(
          '/create-list',
          arguments: CreateListArgs(
            jwt: args.jwt,
            items: args.items,
            index: args.index,
          ),
        );
      } else if (result is RequestError<String>) {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg:
              result.error.isEmpty
                  ? 'Error: ${result.errorType()}'
                  : result.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('New item')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 150, horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              enableSuggestions: false,
              controller: itemNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Item name",
              ),
              validator: (value) => isEmptyValidator(value),
            ),
            FilledButton(onPressed: null, child: Text('Create')),
          ],
        ),
      ),
    );
  }
}
