import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/category_select_card.dart';
import 'package:grocery_flutter/components/recipe_select_card.dart';
import 'package:grocery_flutter/components/show_error.dart';
import 'package:grocery_flutter/helpers/clamp.dart';
import 'package:grocery_flutter/http/grocery-list/grocery_list_controller.dart';
import 'package:grocery_flutter/http/item/item_controller.dart';
import 'package:grocery_flutter/http/recipe/recipe_controller.dart';
import 'package:grocery_flutter/http/requests/request_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/models/full_recipe_model.dart';
import 'package:grocery_flutter/models/recipe_info.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';
import 'package:grocery_flutter/pages/simple_forms/create_list_item/create_list_item_args.dart';
import 'package:grocery_flutter/state/global_state.dart';

class CreateListPage extends StatefulWidget {
  const CreateListPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  bool startedFetching = false;
  List<CategoryModel>? items = null;
  List<FullRecipeModel>? recipes = null;
  List<ShortItem> requests = List.empty();

  Future<void> getRecipes() async {
    final controller = RecipeController(jwt!);
    final RequestResult<void> result = await controller.getAllRecipes();
    if (!mounted) return;
    if (result is RequestSuccess<List<RecipeInfo>>) {
      setState(() {
        recipes =
            result.result
                .map((x) => FullRecipeModel(recipe: x, items: null))
                .toList();
      });
      for (int i = 0; i < recipes!.length; i++) {
        Future.microtask(() async {
          print("Getting ingredients for ${recipes![i].recipe.name}");
          final ingredientsResult = await controller.getIngredients(
            recipes![i].recipe.id,
          );
          if (!mounted) return;
          if (ingredientsResult is RequestSuccess<List<ShortItem>>) {
            print("It has ${ingredientsResult.result.length} ingredients");
            setState(() {
              recipes![i].items = ingredientsResult.result;
            });
          } else {
            print("Failed");
            showError(context, ingredientsResult as RequestError);
          }
        });
      }
    } else {
      setState(() {
        recipes = List.empty();
      });
    }
  }

  Future<void> getItems() async {
    if (items != null) return;
    final controller = ItemController(jwt!);
    var result = await controller.getItemsInGroup();
    if (result is RequestSuccess) {
      result = result as RequestSuccess<List<CategoryModel>?>;
      setState(() {
        items = (result as RequestSuccess).result;
      });
    } else if (result is RequestError) {
      Fluttertoast.showToast(msg: (result as RequestError).error);
    } else {
      Fluttertoast.showToast(msg: "Invalid type");
    }
  }

  void saveList() async {
    var result = await GroceryListController(jwt!).createList(items!);
    if (!mounted) return;
    if (result is RequestSuccess) {
      // delete all requests, since we've made a list
      final requestsResult = await RequestController(jwt!).deleteAllRequests();
      if (!mounted) return;
      if (requestsResult is RequestSuccess) {
        Navigator.of(context).pop();
      } else if (requestsResult is RequestError) {
        showError(context, requestsResult);
      }
    } else if (result is RequestError) {
      showError(context, result);
    }
  }

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

  Future<void> getRequests() async {
    if (recipes != null) return;
    final controller = RequestController(jwt!);
    final result = await controller.getRequestedItems();
    if (!mounted) return;
    if (result is RequestSuccess<List<ShortItem>>) {
      setState(() => requests = result.result);
    } else if (result is RequestError<List<ShortItem>>) {
      showError(context, result as RequestError);
    }
  }

  void load() async {
    // these should run concurrently to avoid several round trips of lag
    final recipesQuery = getRecipes();
    final itemsQuery = getItems();
    final requestsQuery = getRequests();
    await recipesQuery;
    await itemsQuery;
    await requestsQuery;
    for (ShortItem item in requests) updateItemQuantity(item.id, item.quantity);
  }

  void updateRecipeQuantity(String recipeId, int delta) {
    final recipe = recipes?.firstWhereOrNull(
      (recipe) => recipe.recipe.id == recipeId,
    );
    if (recipe == null) return;
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
    if (args != null) {
      setState(() {
        recipes = args.recipes;
        items = args.items;
        requests = List.empty();
        startedFetching = true;
      });
    }
    if (!startedFetching) {
      setState(() => startedFetching = true);
      load();
    }
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 12,
        children: [
          FloatingActionButton(
            onPressed: () => saveList(),
            child: Icon(Icons.save),
          ),
          FloatingActionButton.extended(
            label: const Text("New category"),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/create-category',
                arguments: CreateListArgs(items ?? [], recipes ?? []),
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
          if (recipes != null)
            RecipeSelectCard(
              recipes: recipes!,
              onDecrement: (id) => updateRecipeQuantity(id, -1),
              onIncrement: (id) => updateRecipeQuantity(id, 1),
            )
          else
            SizedBox.shrink(),
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
                        arguments: CreateItemArgs(
                          category.id,
                          CreateListArgs(items ?? [], recipes ?? []),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
