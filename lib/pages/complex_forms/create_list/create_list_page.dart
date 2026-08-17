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
import 'package:grocery_flutter/pages/complex_forms/edit_category/edit_category_args.dart';
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

  get currentState => CreateListArgs(items ?? [], recipes ?? []);

  final requestController = RequestController(jwt!);
  final recipeController = RecipeController(jwt!);
  final itemController = ItemController(jwt!);

  Future<void> getRecipes() async {
    final RequestResult<void> result = await recipeController.getAllRecipes();
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
          final ingredientsResult = await recipeController.getIngredients(
            recipes![i].recipe.id,
          );
          if (!mounted) return;
          if (ingredientsResult is RequestSuccess<List<ShortItem>>) {
            setState(() {
              recipes![i].items = ingredientsResult.result;
            });
          } else {
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
    var result = await itemController.getItemsInGroup();
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
    final result = await requestController.getRequestedItems();
    if (!mounted) return;
    if (result is RequestSuccess<List<ShortItem>>) {
      setState(() => requests = result.result);
    } else if (result is RequestError<List<ShortItem>>) {
      showError(context, result as RequestError);
    }
  }

  Future<void> load() async {
    // these should run concurrently to avoid several round trips of lag
    await Future.wait([getRecipes(), getItems(), getRequests()]);
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
                        arguments: CreateItemArgs(category.id, currentState),
                      );
                    }
                  },
                  onEditCategory:
                      () => Navigator.of(context).pushNamed(
                        '/edit-category',
                        arguments: EditCategoryArgs(currentState, category),
                      ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
