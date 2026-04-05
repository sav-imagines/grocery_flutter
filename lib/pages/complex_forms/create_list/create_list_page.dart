import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/category_select_card.dart';
import 'package:grocery_flutter/components/recipe_select_card.dart';
import 'package:grocery_flutter/helpers/clamp.dart' show clamp;
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

  refresh(ItemController controller) {
    var result = controller.getItemsInGroup();
    result.then((value) {
      if (value is RequestSuccess) {
        value = value as RequestSuccess<List<CategoryModel>?>;
        setState(() {
          items = (value as RequestSuccess).result;
        });
      } else if (value is RequestError) {
        Fluttertoast.showToast(msg: (value as RequestError).error);
      } else {
        Fluttertoast.showToast(msg: "Invalid type");
      }
    });
  }

  void updateItemQuantity(ShortItem item, int newQuantity) {
    if (item.quantity == newQuantity) return;
    if (mounted) {
      setState(() {
        item.quantity = newQuantity;
      });
    }
  }

  void changeItemQuantity(String id, int delta) {
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
        foundItem!.quantity += delta;
      });
  }

  void changeRecipeQuantity(String recipeId, int delta) {
    final recipe = recipes?.firstWhereOrNull(
      (recipe) => recipe.recipe.id == recipeId,
    );
    if (recipe == null) return;
    if (mounted)
      setState(() {
        recipe.quantity += delta;
      });
    for (ShortItem item in recipe.items ?? List.empty()) {
      changeItemQuantity(item.id, delta);
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
              onDecrement: (id) => changeRecipeQuantity(id, -1),
              onIncrement: (id) => changeRecipeQuantity(id, 1),
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
                    changeItemQuantity(id, 1);
                  },
                  onDecrement: (id) {
                    changeItemQuantity(id, -1);
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
