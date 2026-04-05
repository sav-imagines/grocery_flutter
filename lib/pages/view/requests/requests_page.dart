import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/ingredient_card.dart';
import 'package:grocery_flutter/http/requests/request_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';
import 'package:grocery_flutter/models/short_item.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  List<ShortItem>? requestedItems = null;
  List<ShortItem> changedItems = [];

  void getRequests(RequestController controller) async {
    final RequestResult<List<ShortItem>> result =
        await controller.getRequestedItems();
    if (result is RequestSuccess<List<ShortItem>>) {
      var recipes = result.result;
      if (mounted) {
        setState(() {
          requestedItems = recipes;
        });
      }
    } else {
      var errorResult = result as RequestError<List<ShortItem>?>;
      if (mounted) {
        setState(() {
          requestedItems = List.empty();
        });
      }
      Fluttertoast.showToast(msg: "Error '${errorResult.error}' >:[");
    }
  }

  void updateRequests(RequestController controller) async {
    final RequestResult<void> result = await controller.updateItems(
      changedItems,
    );
    if (result is RequestSuccess<void>) {
      if (mounted) {
        for (var item in changedItems) {
          var existingItem = requestedItems!.firstWhere((x) => x.id == item.id);
          setState(() {
            existingItem.quantity = item.quantity;
          });
          if (existingItem.quantity == 0) {
            setState(() {
              requestedItems!.remove(existingItem);
            });
          }
        }
        setState(() {
          changedItems = [];
        });
      }
    } else {
      var errorResult = result as RequestError<void>;
      Fluttertoast.showToast(msg: "Error '${errorResult.error}' >:[");
    }
  }

  updateItem(ShortItem item, int newQuantity) {
    if (mounted) {
      if (changedItems.any((i) => i.id == item.id)) {
        setState(() {
          changedItems.firstWhere((i) => i.id == item.id).quantity =
              newQuantity;
        });
      } else {
        setState(() {
          changedItems.add(
            ShortItem(id: item.id, name: item.name, quantity: newQuantity),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String jwt = ModalRoute.of(context)!.settings.arguments as String;
    if (requestedItems == null) {
      getRequests(RequestController(jwt: jwt));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Requests')),
      floatingActionButton: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed:
                () => Navigator.of(
                  context,
                ).pushNamed("/request-item", arguments: jwt),
          ),
          changedItems.isNotEmpty
              ? FloatingActionButton(
                onPressed: () => updateRequests(RequestController(jwt: jwt)),
                child: Icon(Icons.save),
              )
              : SizedBox.shrink(),
        ],
      ),
      body:
          requestedItems == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  getRequests(RequestController(jwt: jwt));
                  setState(() {
                    changedItems = [];
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child:
                      requestedItems!.isEmpty
                          ? ListView(
                            children: [
                              Center(
                                child: Text("No items have been requested"),
                              ),
                            ],
                          )
                          : ListView.separated(
                            separatorBuilder:
                                (context, i) => SizedBox.square(dimension: 5),
                            itemCount: requestedItems!.length,
                            itemBuilder: (context, index) {
                              var item = requestedItems![index];
                              item = changedItems.firstWhere(
                                (x) => x.id == item.id,
                                orElse: () => item,
                              );
                              return IngredientCard(
                                info: GroceryListItemDisplay(
                                  id: item.id,
                                  name: item.name,
                                  quantity: item.quantity,
                                  categoryId: "",
                                  categoryName: "",
                                ),
                                onDecrement: () {
                                  updateItem(item, item.quantity - 1);
                                },
                                onIncrement: () {
                                  updateItem(
                                    item,
                                    item.quantity < 99 ? item.quantity + 1 : 99,
                                  );
                                },
                                onRemove: () {
                                  updateItem(
                                    item,
                                    item.quantity > 0 ? item.quantity - 1 : 0,
                                  );
                                },
                              );
                            },
                          ),
                ),
              ),
    );
  }
}
