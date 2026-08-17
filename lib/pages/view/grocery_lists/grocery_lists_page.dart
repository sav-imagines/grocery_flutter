import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/grocery-list/grocery_list_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/pages/view/grocery_list_info/grocery_list_info_args.dart';
import 'package:grocery_flutter/components/grocery_list_card.dart';
import 'package:grocery_flutter/models/grocery_list_display.dart';
import 'package:grocery_flutter/state/global_state.dart';

class ViewGroceryListsPage extends StatefulWidget {
  const ViewGroceryListsPage({super.key});

  @override
  State<ViewGroceryListsPage> createState() => _ViewGroceryListsPageState();
}

class _ViewGroceryListsPageState extends State<ViewGroceryListsPage> {
  List<GroceryListDisplay>? lists = null;
  final controller = GroceryListController(jwt!);

  Future<void> refresh() async {
    var result = await controller.getAllLists();
    if (!mounted) return;
    switch (result) {
      case RequestSuccess(result: final displays):
        setState(() {
          lists = displays;
        });
      case RequestError(error: final error):
        Fluttertoast.showToast(msg: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lists == null) {
      refresh();
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
                    onRefresh: () => refresh(),
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
                                            ),
                                          ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/create-list');
        },
      ),
    );
  }
}
