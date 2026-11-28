import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/category_view.dart';
import 'package:grocery_flutter/http/grocery-list/grocery_list_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/pages/view/grocery_list_info/grocery_list_info_args.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';

class GroceryListHistoryPage extends ConsumerWidget {
  const GroceryListHistoryPage({super.key});

  Map<String, List<GroceryListItemDisplay>> sortInBuckets(
    List<GroceryListItemDisplay> items,
  ) {
    Map<String, List<GroceryListItemDisplay>> out = {};
    for (var item in items) {
      if (out[item.categoryName] == null) {
        out[item.categoryName] = [item];
      } else {
        out[item.categoryName]!.add(item);
      }
    }
    return out;
  }

  // refresh(GroceryListController controller, GroceryListInfoArgs args) {
  //   controller.getListInfo(args.list.listId).then((value) {
  //     if (value is RequestSuccess<List<GroceryListItemDisplay>?>) {
  //       setState(() {
  //         items = sortInBuckets((value as RequestSuccess).result);
  //       });
  //     } else if (value is RequestError<List<GroceryListItemDisplay>>) {
  //       Fluttertoast.showToast(msg: (value as RequestError).error);
  //     } else {
  //       Fluttertoast.showToast(msg: "Returned value of unknown type");
  //     }
  //   });
  // }
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as GroceryListInfoArgs;
    final items = ref.watch(getListInfoProvider(args.list.listId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery list"),
        actions: [
          IconButton(
            //TODO: confirm??????
            onPressed: () async {
              var result = await deleteList(args.list.listId);
              if (result is RequestSuccess) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } else if (result is RequestError) {
                Fluttertoast.showToast(msg: result.toString());
              } else {
                Fluttertoast.showToast(msg: result.toString());
              }
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: switch (items) {
        AsyncData(:final value) when value.isEmpty => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 72),
              Text("Empty cart"),
            ],
          ),
        ),
        AsyncData(:final value) => () {
          final buckets = sortInBuckets(value).entries;
          return ListView.separated(
            separatorBuilder: (ctx, i) => SizedBox(height: 12),
            itemCount: buckets.length,
            // padding: EdgeInsetsGeometry.all(24),
            itemBuilder: (ctx, i) => CategoryView(items: buckets.skip(i).first),
          );
        }(),
        AsyncError(:final error) => ErrorWidget(error),
        AsyncLoading() => Center(child: CircularProgressIndicator()),
      },
    );
  }
}
