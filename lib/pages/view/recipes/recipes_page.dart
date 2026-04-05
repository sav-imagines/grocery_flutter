import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/recipe-controller/recipe_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/pages/complex_forms/create_recipe/create_recipe_args.dart';
import 'package:grocery_flutter/models/recipe_display.dart';
import 'package:grocery_flutter/models/recipe_info.dart';
import 'package:grocery_flutter/components/recipe_list_card.dart';

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
      Fluttertoast.showToast(
        msg: "Image error: ${(pictureResult as RequestError).error}",
      );
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
            print(errorResult);
            Fluttertoast.showToast(msg: "Error '${errorResult.error}' >:[");
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
      Fluttertoast.showToast(msg: recipeDisplays!.length.toString());
      return response.result;
    } else {
      var responseError = response as RequestError;
      Fluttertoast.showToast(
        msg: "Could not get ingredients due to error '${responseError.error}'",
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String jwt = ModalRoute.of(context)!.settings.arguments as String;
    var controller = RecipeController(jwt: jwt);
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
                jwt: jwt,
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
                                  isDismissible: false,
                                  isScrollControlled: true,
                                  context: context,
                                  builder:
                                      (context) => DraggableScrollableSheet(
                                        maxChildSize: 0.6,
                                        initialChildSize: 0.6,
                                        expand: false,
                                        builder:
                                            (
                                              context,
                                              scrollController,
                                            ) => Padding(
                                              padding: EdgeInsets.all(10),
                                              child: ListView(
                                                children: [
                                                  Row(
                                                    // fill full width of modal bottom sheet
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      SizedBox.shrink(),
                                                    ],
                                                  ),
                                                  item.imageBytes != null
                                                      ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        child: Image.memory(
                                                          item.imageBytes!,
                                                        ),
                                                      )
                                                      : const Text(
                                                        "No image was detected???",
                                                      ),
                                                  Text(
                                                    item.info.name,
                                                    style:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall,
                                                  ),
                                                  Text(
                                                    item.info.description,
                                                    style:
                                                        Theme.of(
                                                          context,
                                                        ).textTheme.bodyLarge,
                                                  ),
                                                  ingredients == null
                                                      ? Center(
                                                        child: Text(
                                                          "Could not fetch ingredients",
                                                        ),
                                                      )
                                                      : Column(
                                                        spacing: 12,
                                                        children:
                                                            ingredients
                                                                .map(
                                                                  (
                                                                    ingredient,
                                                                  ) => Row(
                                                                    children:
                                                                        [
                                                                          SizedBox(
                                                                            width:
                                                                                60,
                                                                            child: Text(
                                                                              ingredient.quantity.toString(),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            ingredient.name,
                                                                          ),
                                                                        ].toList(),
                                                                  ),
                                                                )
                                                                .toList(),
                                                      ),
                                                ],
                                              ),
                                            ),
                                      ),
                                );
                                Fluttertoast.showToast(msg: "Finished!");
                              },
                            );
                          },
                        ),
              ),
    );
  }
}
