import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRecipeItemPage extends ConsumerStatefulWidget {
  final TextEditingController itemNameController = TextEditingController();

  CreateRecipeItemPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CreateRecipeItemPageState();
  }
}

class _CreateRecipeItemPageState extends ConsumerState<CreateRecipeItemPage> {
  TextEditingController itemNameController = TextEditingController();
  isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  // submitItem(CreateItemModel item, CreateItemArgs args) async {
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
