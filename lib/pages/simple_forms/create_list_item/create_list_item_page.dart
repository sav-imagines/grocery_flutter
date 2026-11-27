import 'package:flutter/material.dart';
import 'package:grocery_flutter/pages/simple_forms/create_list_item/create_list_item_args.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  bool hasInitialized = false;
  String categoryId = '';
  TextEditingController itemNameController = TextEditingController();

  // final itemController = ItemController(jwt!);

  String? isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  // void submitItem(
  //   // ItemController controller,
  //   CreateItemModel item,
  //   CreateItemArgs args,
  // ) async {
  //   // var result = await controller.createItem(item);
  //
  //   if (mounted) {
  //     if (result is RequestSuccess<String>) {
  //       args.state.items
  //           .firstWhere((category) => category.id == item.categoryId)
  //           .items
  //           .add(ShortItem(id: result.result, name: item.name, quantity: 1));
  //       Navigator.of(context).pop();
  //       Navigator.of(
  //         context,
  //       ).popAndPushNamed('/create-list', arguments: args.state);
  //     } else if (result is RequestError<String>) {
  //       if (!mounted) return;
  //       showError(context, result);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CreateItemArgs;
    if (!hasInitialized) {
      setState(() {
        hasInitialized = true;
        categoryId = args.categoryId ?? '';
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('New item')),
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
              controller: itemNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Item name",
              ),
              validator: (value) => isEmptyValidator(value),
            ),
            FilledButton(
              onPressed: null,

              // () => submitItem(
              //   itemController,
              //   CreateItemModel(
              //     categoryId: categoryId,
              //     name: itemNameController.text,
              //   ),
              //   args,
              // ),
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
