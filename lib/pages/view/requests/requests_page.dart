import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_flutter/components/ingredient_card.dart';
import 'package:grocery_flutter/http/requests/request_controller.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/state/global_state.dart';

class RequestsPage extends ConsumerStatefulWidget {
  const RequestsPage({super.key});

  @override
  ConsumerState<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends ConsumerState<RequestsPage> {
  List<ShortItem> changedItems = [];

  // void getRequests(RequestController controller) async {
  //   final RequestResult<List<ShortItem>> result =
  //       await controller.getRequestedItems();
  //   if (result is RequestSuccess<List<ShortItem>>) {
  //     if (mounted) {
  //       setState(() {
  //         requestedItems = result.result;
  //       });
  //     }
  //   } else {
  //     var errorResult = result as RequestError<List<ShortItem>?>;
  //     if (mounted) {
  //       setState(() {
  //         requestedItems = List.empty();
  //       });
  //     }
  //     Fluttertoast.showToast(msg: "Error '${errorResult.error}' >:[");
  //   }
  // }

  // void updateRequests(RequestController controller) async {
  //   final RequestResult<void> result = await controller.updateItems(
  //     changedItems,
  //   );
  //   if (result is RequestSuccess<void>) {
  //     if (mounted) {
  //       for (var item in changedItems) {
  //         var existingItem = requestedItems!.firstWhere((x) => x.id == item.id);
  //         setState(() {
  //           existingItem.quantity = item.quantity;
  //         });
  //         if (existingItem.quantity == 0) {
  //           setState(() {
  //             requestedItems!.remove(existingItem);
  //           });
  //         }
  //       }
  //       setState(() {
  //         changedItems = [];
  //       });
  //     }
  //   } else {
  //     var errorResult = result as RequestError<void>;
  //     Fluttertoast.showToast(msg: "Error '${errorResult.error}' >:[");
  //   }
  // }

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
    final requestedItems = ref.watch(getRequestedItemsProvider);
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
                onPressed:
                    () async => ref.refresh(getRequestedItemsProvider.future),
                child: Icon(Icons.save),
              )
              : SizedBox.shrink(),
        ],
      ),
      body: switch (requestedItems) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () async {
            // getRequests(RequestController(jwt!));
            setState(() {
              changedItems = [];
            });
          },
          child: Padding(
            padding: EdgeInsets.all(5),
            child:
                value.isEmpty
                    ? ListView(
                      children: [
                        Center(child: Text("No items have been requested")),
                      ],
                    )
                    : ListView.separated(
                      separatorBuilder:
                          (context, i) => SizedBox.square(dimension: 5),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        var item = value[index];
                        item = changedItems.firstWhere(
                          (x) => x.id == item.id,
                          orElse: () => item,
                        );
                        return IngredientCard(
                          info: item,
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
        AsyncError(:final error) => Center(child: Text(error.toString())),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
