import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_flutter/http/grocery-list/grocery_list_controller.dart';
import 'package:grocery_flutter/pages/view/grocery_list_info/grocery_list_info_args.dart';
import 'package:grocery_flutter/components/grocery_list_card.dart';

class ViewGroceryListsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(getAllListsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Grocery lists')),
      body: switch (lists) {
        AsyncData(:final value) =>
          value.isEmpty
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
                onRefresh: () => ref.refresh(getAllListsProvider.future),
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: <Widget>[
                    Wrap(
                      runSpacing: 10,
                      children:
                          value
                              .map(
                                (e) => GroceryListCard(
                                  info: e,
                                  onTap:
                                      () => Navigator.of(context).pushNamed(
                                        '/view-grocery-list',
                                        arguments: GroceryListInfoArgs(list: e),
                                      ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
        AsyncError(:final error) => Center(child: Text(error.toString())),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/create-list');
        },
      ),
    );
  }
}
