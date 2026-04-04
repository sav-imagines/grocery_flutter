import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/category_select_card.dart';
import 'package:grocery_flutter/http/item/item_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';

class CreateListPage extends StatefulWidget {
  const CreateListPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  late List<CategoryModel>? items = null;

  refresh(ItemController controller) {
    var result = controller.getItemsInGroup();
    result.then((value) {
      if (value is RequestSuccess) {
        value = value as RequestSuccess<List<CategoryModel>?>;
        setState(() {
          items = (value as RequestSuccess).result;
        });
      } else if (value is RequestError) {
        Fluttertoast.showToast(msg: (value as RequestError).error);
      } else {
        Fluttertoast.showToast(msg: "Invalid type");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CreateListArgs;
    ItemController controller = ItemController(jwt: args.jwt);
    if (args.items != null && items == null) {
      items = args.items;
    } else if (items == null) {
      refresh(controller);
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("New category"),
        onPressed: () {
          Navigator.of(
            context,
          ).pushNamed('/create-category', arguments: args.jwt);
        },
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("New grocery list"),
      ),
      body: ListView.builder(
        itemBuilder: (context, columnIndex) {
          if (items?.isEmpty ?? true) {
            return null;
          } else if (items!.length <= columnIndex) {
            return null;
          }
          CategoryModel category = items![columnIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategorySelectCard(
                category: category,
                onDecrement: () {},
                onIncrement: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}
