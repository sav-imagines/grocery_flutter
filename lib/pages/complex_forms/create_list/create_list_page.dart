import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/category_select_card.dart';
import 'package:grocery_flutter/components/recipe_select_card.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/helpers/clamp.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/models/full_recipe_model.dart';
import 'package:grocery_flutter/models/recipe_info.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';

class CreateListPage extends StatefulWidget {
  final List<CategoryModel> categories;
  final List<ShortItem> requests;
  final List<FullRecipeModel> recipes;

  const CreateListPage({
    super.key,
    required this.categories,
    required this.requests,
    required this.recipes,
  });

  @override
  State<StatefulWidget> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  late List<CategoryModel> items;
  late List<ShortItem> requests;
  late List<FullRecipeModel> recipes;

  @override
  void initState() {
    super.initState();
    setState(() {
      items = widget.categories;
      requests = widget.requests;
      recipes = widget.recipes;
    });
  }

  // void saveList() async {
  //   var result = await GroceryListController(jwt!).createList(items!);
  //   if (!mounted) return;
  //   if (result is RequestSuccess) {
  //     // delete all requests, since we've made a list
  //     final requestsResult = await RequestController(jwt!).deleteAllRequests();
  //     if (!mounted) return;
  //     if (requestsResult is RequestSuccess) {
  //       Navigator.of(context).pop();
  //     } else if (requestsResult is RequestError) {
  //       showError(context, requestsResult);
  //     }
  //   } else if (result is RequestError) {
  //     showError(context, result);
  //   }
  // }

  void updateItemQuantity(String id, int delta) {
    ShortItem? foundItem = null;

    for (CategoryModel cat in items ?? List.empty()) {
      for (ShortItem item in cat.items) {
        if (item.id == id) {
          foundItem = item;
          break;
        }
      }
      if (foundItem != null) break;
    }

    if (!mounted) return;
    if (foundItem != null) {
      setState(
        () => foundItem!.quantity = clamp(foundItem.quantity + delta, 0, 99),
      );
    } else
      showErrorMessage(
        context,
        "Did not find an item of id $id",
        "Missing item",
      );
  }

  // Future<void> getRequests() async {
  //   final result = await requestController.getRequestedItems();
  //   if (!mounted) return;
  //   if (result is RequestSuccess<List<ShortItem>>) {
  //     setState(() => requests = result.result);
  //   } else if (result is RequestError<List<ShortItem>>) {
  //     showError(context, result as RequestError);
  //   }
  // }

  // Future<void> load() async {
  //   // these should run concurrently to avoid several round trips of lag
  //   await Future.wait([getItems(), getRequests()]);
  //   for (ShortItem item in requests) updateItemQuantity(item.id, item.quantity);
  // }

  void updateRecipeQuantity(int recipeIdx, int delta) {
    final recipe = recipes[recipeIdx];
    if (mounted)
      setState(() {
        recipe.quantity = clamp(recipe.quantity + delta, 0, 99);
      });
    for (ShortItem item in recipe.items ?? List.empty()) {
      updateItemQuantity(item.id, delta);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CreateListArgs?;
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 12,
        children: [
          FloatingActionButton(
            // onPressed: () => saveList(),
            onPressed: null,
            child: Icon(Icons.save),
          ),
          FloatingActionButton.extended(
            label: const Text("New category"),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/create-category',
                arguments: CreateListArgs(items ?? [], []),
              );
            },
            icon: const Icon(Icons.add),
            heroTag: null,
          ),
        ],
      ),
      appBar: AppBar(title: const Text("New grocery list")),
      body: ListView(
        children: [
          RecipeSelectCard(
            recipes: recipes,
            onDecrement: (id) => updateRecipeQuantity(id, -1),
            onIncrement: (id) => updateRecipeQuantity(id, 1),
          ),
          for (CategoryModel category in items ?? List.empty())
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategorySelectCard(
                  category: category,
                  onIncrement: (id) {
                    updateItemQuantity(id, 1);
                  },
                  onDecrement: (id) {
                    updateItemQuantity(id, -1);
                  },
                  onCreateItem: () {
                    if (mounted) {
                      Navigator.of(context).pushNamed(
                        '/create-list-item',
                        // arguments: CreateItemArgs(category.id, currentState),
                      );
                    }
                  },
                  onEditCategory:
                      () => Navigator.of(context).pushNamed(
                        '/edit-category',
                        // arguments: EditCategoryArgs(currentState, category),
                      ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
