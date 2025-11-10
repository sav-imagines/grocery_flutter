import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/recipe-controller/recipe_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
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
  late RecipeController? controller = null;
  late List<RecipeDisplay>? recipeDisplays = null;

  getRecipes(RecipeController controller) async {
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
        setState(
          () =>
              recipeDisplays =
                  recipes
                      .map(
                        (recipe) =>
                            RecipeDisplay(info: recipe, imageBytes: null),
                      )
                      .toList(),
        );
        for (int i = 0; i < recipes.length; i++) {
          final element = recipes[i];
          if (element.pictureName != null && element.pictureName!.isNotEmpty) {
            Future.microtask(() async {
              RequestResult<Uint8List?> pictureResult = await controller
                  .getPicture(element.pictureName!);
              if (pictureResult is RequestSuccess<Uint8List?>) {
                if (mounted && recipeDisplays != null) {
                  setState(() {
                    recipeDisplays![i].imageBytes = pictureResult.result;
                  });
                }
              } else {
                Fluttertoast.showToast(
                  msg: "Image error: ${(pictureResult as RequestError).error}",
                );
              }
            });
          }
        }
      }
    } else {
      var errorResult = result as RequestError<List<RecipeInfo>?>;
      if (mounted) {
        setState(() {
          recipeDisplays = List.empty();
        });
      }
      Fluttertoast.showToast(msg: "Error '${errorResult.error}' >:[");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String jwt = ModalRoute.of(context)!.settings.arguments as String;
    if (recipeDisplays == null) {
      if (controller == null) {
        setState(() => controller = RecipeController(jwt: jwt));
      }
      getRecipes(controller!);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Recipes'),
      ),
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
                onRefresh: () => getRecipes(controller!),
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
                              onTap: () {
                                // TODO: Navigate to a recipe view that lets you edit
                                showBottomSheet(
                                  clipBehavior: Clip.hardEdge,
                                  context: context,
                                  builder: (context) {
                                    final item = recipeDisplays![index];
                                    return Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [SizedBox.shrink()],
                                          ),
                                          item.imageBytes != null
                                              ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                clipBehavior: Clip.hardEdge,
                                                child: Image.memory(
                                                  item.imageBytes!,
                                                  // width: 300,
                                                  // height: 300,
                                                ),
                                              )
                                              : const Text(
                                                "No image was detected???",
                                              ),

                                          Icon(Icons.add),
                                          Text(item.info.name),
                                          Text(item.info.description),
                                          Text(item.info.steps),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
              ),
    );
  }
}
