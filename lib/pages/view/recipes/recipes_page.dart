import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:grocery_flutter/components/show_error.dart' show showError;
import 'package:grocery_flutter/http/recipe-controller/recipe_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/pages/complex_forms/create_recipe/create_recipe_args.dart';
import 'package:grocery_flutter/models/recipe_display.dart';
import 'package:grocery_flutter/models/recipe_info.dart';
import 'package:grocery_flutter/components/recipe_list_card.dart';
import 'package:grocery_flutter/pages/view/recipes/recipe_preview.dart';
import 'package:grocery_flutter/state/global_state.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<RecipeDisplay>? recipeDisplays = null;
  List<List<ShortItem>?> recipeIngredients = List.empty();

  Future<void> getImage(int index, RecipeController controller) async {
    final element = recipeDisplays![index];
    Uint8List? cachedPicture =
        await (await DefaultCacheManager().getFileFromCache(
          "recipePicture/${element.info.pictureName}",
        ))?.file.readAsBytes();
    if (cachedPicture?.isNotEmpty ?? false) {
      if (mounted) {
        setState(() {
          recipeDisplays![index].imageBytes = cachedPicture;
        });
      }
      return;
    }
    RequestResult<Uint8List?> pictureResult = await controller.getPicture(
      element.info.pictureName!,
    );
    if (pictureResult is RequestSuccess<Uint8List?>) {
      if (mounted && recipeDisplays != null) {
        setState(() {
          recipeDisplays![index].imageBytes = pictureResult.result;
        });
        DefaultCacheManager().putFile(
          "recipePicture/${element.info.pictureName}",
          pictureResult.result!,
        );
      }
    } else {
      if (mounted)
        showError(context, (pictureResult as RequestError<Uint8List?>));
    }
  }

  Future<void> getRecipes(RecipeController controller) async {
    if (mounted) {
      setState(() => recipeDisplays = null);
    }
    final RequestResult<List<RecipeInfo>> result =
        await controller.getAllRecipes();
    if (result is RequestSuccess<List<RecipeInfo>>) {
      var recipes = result.result;
      if (recipes.isEmpty) {
        if (mounted) {
          setState(() {
            recipeDisplays = List.empty();
          });
        }
      } else {
        setState(() {
          recipeDisplays =
              recipes
                  .map(
                    (recipe) => RecipeDisplay(info: recipe, imageBytes: null),
                  )
                  .toList();
          recipeIngredients = List.filled(recipeDisplays!.length, null);
        });
        for (int i = 0; i < recipes.length; i++) {
          if (recipes[i].pictureName?.isNotEmpty ?? true) {
            Future.microtask(() async {
              await getImage(i, controller);
            });
          } else {
            var errorResult = result as RequestError<List<RecipeInfo>?>;
            if (mounted) showError(context, errorResult);
          }
        }
      }
    }
  }

  Future<List<ShortItem>?> getIngredients(
    int index,
    RecipeController controller,
  ) async {
    if (recipeDisplays == null || recipeDisplays!.length <= index) {
      return null;
    }
    // if (recipeIngredients[index] != null) return; // already fetched

    var response = await controller.getIngredients(
      recipeDisplays![index].info.id,
    );
    if (response is RequestSuccess<List<ShortItem>>) {
      return response.result;
    } else {
      var responseError = response as RequestError;
      if (mounted) showError(context, responseError);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = RecipeController(jwt!);
    if (recipeDisplays == null) {
      getRecipes(controller);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed:
            () => Navigator.of(context).pushNamed(
              "/create-recipe",
              arguments: CreateRecipeArgs(
                imageBytes: List.empty(growable: true),
                ingredients: List.empty(growable: true),
              ),
            ),
      ),
      body:
          recipeDisplays == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  await getRecipes(controller);
                  await DefaultCacheManager().emptyCache();
                },
                child:
                    recipeDisplays!.isEmpty
                        ? const Center(
                          child: Text("You don't have any recipes"),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.all(5),
                          separatorBuilder:
                              (c, i) => const SizedBox.square(dimension: 10),
                          itemCount: recipeDisplays?.length ?? 0,

                          itemBuilder: (context, index) {
                            return RecipeListCard(
                              info: recipeDisplays![index],
                              onTap: () async {
                                // TODO: Navigate to a recipe view that lets you edit
                                final ingredients = await getIngredients(
                                  index,
                                  controller,
                                );
                                if (ingredients == null)
                                  getIngredients(index, controller);
                                final item = recipeDisplays![index];
                                if (!context.mounted) return;
                                showModalBottomSheet(
                                  showDragHandle: true,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: recipePreview(item, ingredients),
                                );
                              },
                            );
                          },
                        ),
              ),
    );
  }
}
