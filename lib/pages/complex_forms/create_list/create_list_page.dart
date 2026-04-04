import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/category_select_card.dart';
import 'package:grocery_flutter/helpers/clamp.dart' show clamp;
import 'package:grocery_flutter/http/item/item_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';
import 'package:grocery_flutter/pages/simple_forms/create_list_item/create_list_item_args.dart';

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

  void updateItemQuantity(ShortItem item, int newQuantity) {
    if (item.quantity == newQuantity) return;
    if (mounted) {
      setState(() {
        item.quantity = newQuantity;
      });
    }
  }

  void saveList() {
    // TODO: save shit
    if (mounted) {
      Navigator.of(context).pop();
    }
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 12,
        children: [
          FloatingActionButton(onPressed: saveList, child: Icon(Icons.send)),
          FloatingActionButton.extended(
            label: const Text("New category"),
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed('/create-category', arguments: args.jwt);
            },
            icon: const Icon(Icons.add),
          ),
        ],
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
                onIncrement: (id) {
                  var item = items![columnIndex].items.firstWhere(
                    (item) => item.id == id,
                  );
                  int newQuantity = clamp(item.quantity + 1, 0, 99);
                  updateItemQuantity(item, newQuantity);
                },
                onDecrement: (id) {
                  var item = items![columnIndex].items.firstWhere(
                    (item) => item.id == id,
                  );
                  int newQuantity = clamp(item.quantity - 1, 0, 99);
                  updateItemQuantity(item, newQuantity);
                },
                onCreateItem: () {
                  if (mounted) {
                    Navigator.of(context).pushNamed(
                      '/create-list-item',
                      arguments: CreateItemArgs(
                        jwt: args.jwt,
                        categoryId: category.id,
                        items: items,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
