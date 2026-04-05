import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/grocery-list/grocery_list_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';
import 'package:grocery_flutter/pages/view/grocery_list_info/grocery_list_info_args.dart';
import 'package:grocery_flutter/components/grocery_list_card.dart';
import 'package:grocery_flutter/models/grocery_list_display.dart';

class ViewGroceryListsPage extends StatefulWidget {
  const ViewGroceryListsPage({super.key});

  @override
  State<ViewGroceryListsPage> createState() => _ViewGroceryListsPageState();
}

class _ViewGroceryListsPageState extends State<ViewGroceryListsPage> {
  late List<GroceryListDisplay>? lists = null;

  refresh(GroceryListController controller) {
    controller.getAllLists().then((value) {
      if (value is RequestSuccess) {
        setState(() {
          lists = (value as RequestSuccess).result;
        });
      } else if (value is RequestError) {
        Fluttertoast.showToast(msg: (value as RequestError).error);
      } else {
        Fluttertoast.showToast(msg: value.runtimeType.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String jwt = ModalRoute.of(context)!.settings.arguments as String;
    final controller = GroceryListController(jwt: jwt);
    if (lists == null) {
      refresh(controller);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Grocery lists')),
      body:
          lists == null
              ? Center(child: CircularProgressIndicator())
              : (lists!.isEmpty
                  ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 70),
                        Text(
                          "You haven't made any grocery lists yet",
                          textScaler: TextScaler.linear(1.3),
                        ),
                      ],
                    ),
                  )
                  : RefreshIndicator(
                    child: ListView(
                      padding: EdgeInsets.all(10),
                      children: <Widget>[
                        Wrap(
                          runSpacing: 10,
                          children:
                              lists!
                                  .map(
                                    (e) => GroceryListCard(
                                      info: e,
                                      onTap:
                                          () => Navigator.of(context).pushNamed(
                                            '/view-grocery-list',
                                            arguments: GroceryListInfoArgs(
                                              list: e,
                                              jwt: jwt,
                                            ),
                                          ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                    onRefresh: () {
                      return Future.delayed(
                        Duration(milliseconds: 400),
                        () => refresh(controller),
                      );
                    },
                  )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/create-list',
            arguments: CreateListArgs(jwt: jwt, items: null),
          );
        },
      ),
    );
  }
}
