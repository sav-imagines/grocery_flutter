import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/category_select_card.dart';
import 'package:grocery_flutter/components/recipe_select_card.dart';
import 'package:grocery_flutter/helpers/clamp.dart';
import 'package:grocery_flutter/http/grocery-list/grocery_list_controller.dart';
import 'package:grocery_flutter/http/item/item_controller.dart';
import 'package:grocery_flutter/http/recipe-controller/recipe_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/models/full_recipe_model.dart';
import 'package:grocery_flutter/models/recipe_info.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';
import 'package:grocery_flutter/pages/simple_forms/create_list_item/create_list_item_args.dart';

class CreateListPage extends StatefulWidget {
  const CreateListPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  late List<CategoryModel>? items = null;
  List<FullRecipeModel>? recipes = null;

  void getRecipes(RecipeController controller) async {
    final RequestResult<void> result = await controller.getAllRecipes();
    if (result is RequestSuccess<List<RecipeInfo>>) {
      if (mounted) {
        setState(() {
          recipes =
              result.result
                  .map((x) => FullRecipeModel(recipe: x, items: null))
                  .toList();
        });
      }
      for (int i = 0; i < recipes!.length; i++) {
        Future.microtask(() async {
          final ingredientsResult = await controller.getIngredients(
            recipes![i].recipe.id,
          );
          if (ingredientsResult is RequestSuccess<List<ShortItem>>) {
            setState(() {
              recipes![i].items = ingredientsResult.result;
            });
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          recipes = List.empty();
        });
      }
    }
  }

  void refresh(ItemController controller) async {
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

  void saveList(GroceryListController controller) async {
    var result = await controller.createList(items!);
    if (result is RequestSuccess) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else if (result is RequestError) {
      Fluttertoast.showToast(msg: result.error);
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

    if (mounted && foundItem != null)
      setState(() {
        foundItem!.quantity = clamp(foundItem.quantity + delta, 0, 99);
      });
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
    final args = ModalRoute.of(context)!.settings.arguments as CreateListArgs;
    ItemController controller = ItemController(jwt: args.jwt);
    if (args.items != null && items == null) {
      items = args.items;
    } else if (items == null) {
      refresh(controller);
    }
    if (recipes == null) getRecipes(RecipeController(jwt: args.jwt));
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 12,
        children: [
          FloatingActionButton(
            onPressed: () => saveList(GroceryListController(jwt: args.jwt)),
            child: Icon(Icons.save),
          ),
          FloatingActionButton.extended(
            label: const Text("New category"),
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed('/create-category', arguments: args.jwt);
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
                          jwt: args.jwt,
                          categoryId: category.id,
                          items: items,
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
