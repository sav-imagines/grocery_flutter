import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/item/item_controller.dart';
import 'package:grocery_flutter/http/requests/request_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';
import 'package:grocery_flutter/models/short_item.dart';

class RequestItemPage extends StatefulWidget {
  const RequestItemPage({super.key});

  @override
  State<RequestItemPage> createState() => _RequestItemPageState();
}

class _RequestItemPageState extends State<RequestItemPage> {
  TextEditingController groupNameController = TextEditingController();

  List<GroceryListItemDisplay>? searchIngredientsResults;
  GroceryListItemDisplay? selectedItem = null;

  isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  submitRequestItem(RequestController controller, ShortItem item) async {
    var result = await controller.requestItem(item);
    if (mounted) {
      if (result is RequestSuccess) {
        Navigator.of(context).pop();
      } else if (result is RequestError) {
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

  Future<void> search(ItemController itemController, String query) async {
    final RequestResult<List<GroceryListItemDisplay>> result =
        await itemController.searchItems(query);
    if (result is RequestSuccess<List<GroceryListItemDisplay>>) {
      if (mounted) {
        setState(() {
          searchIngredientsResults = result.result;
        });
      }
    } else {
      Fluttertoast.showToast(msg: (result as RequestError).error);
    }
  }

  void unSearch() {
    setState(() {
      searchIngredientsResults = List.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jwt = ModalRoute.of(context)!.settings.arguments as String;
    final itemController = ItemController(jwt: jwt);
    final requestController = RequestController(jwt: jwt);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Request item ${selectedItem?.name ?? 'None'}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: <Widget>[
            Expanded(
              child:
                  searchIngredientsResults == null ||
                          searchIngredientsResults!.isEmpty
                      ? const Center(child: Text("No results"))
                      : Align(
                        alignment: Alignment.bottomLeft,
                        child: ListView.separated(
                          itemCount: searchIngredientsResults?.length ?? 0,
                          separatorBuilder:
                              (_, _) => SizedBox.square(dimension: 5),
                          itemBuilder: (context, index) {
                            var item = searchIngredientsResults?[index];
                            if (item == null) {
                              throw Exception("Not working");
                            }

                            return GestureDetector(
                              onTap: () {
                                if (context.mounted) {
                                  setState(() {
                                    selectedItem = item;
                                  });
                                }
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsetsGeometry.all(7),
                                  child: Row(children: [Text(item.name)]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
            selectedItem == null
                ? SizedBox.shrink()
                : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(selectedItem!.name),
                ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search",
                    ),
                    onChanged: (newText) {
                      if (newText.isEmpty) {
                        unSearch();
                      } else {
                        search(ItemController(jwt: jwt), newText);
                      }
                    },
                  ),
                ),
                IconButton(onPressed: null, icon: Icon(Icons.add)),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     TextField(
            //       onChanged: (newText) {
            //         if (newText.isEmpty) {
            //           unSearch();
            //         } else {
            //           search(ItemController(jwt: jwt), newText);
            //         }
            //       },
            //     ),
            //     IconButton(onPressed: null, icon: Icon(Icons.add)),
            //   ],
            // ),
            FilledButton(
              onPressed:
                  selectedItem == null
                      ? null
                      : () => submitRequestItem(
                        requestController,
                        searchIngredientsResults![0].toShortItem(),
                      ),
              child: Text('Request'),
            ),
          ],
        ),
      ),
    );
  }
}
