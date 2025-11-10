import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/item/item_controller.dart';
import 'package:grocery_flutter/http/recipe-controller/create_recipe_model.dart';
import 'package:grocery_flutter/http/recipe-controller/recipe_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/pages/complex_forms/create_recipe/create_recipe_args.dart';
import 'package:grocery_flutter/components/ingredient_card.dart';
import 'package:grocery_flutter/components/search_result_card.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';
import 'package:image_picker/image_picker.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  List<Uint8List> imageBytes = List.empty(growable: true);
  List<Image> imageViews = List.empty(growable: true);

  List<GroceryListItemDisplay> ingredients = List.empty(growable: true);
  List<GroceryListItemDisplay> searchIngredientsResults = List.empty(
    growable: true,
  );

  late CreateRecipeArgs? args;

  final carouselController = CarouselSliderController();

  int currentPage = 0;

  bool canSubmit() {
    return (_formKey.currentState?.validate() ?? false) &&
        ingredients.isNotEmpty;
  }

  Future<void> submit(RecipeController controller) async {
    final response = await controller.createRecipe(
      CreateRecipeModel(
        name: nameController.text,
        description: descriptionController.text,
        instructions: instructionsController.text,
        pictures: imageBytes,
        items: ingredients,
      ),
    );
    if (response is RequestSuccess) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: Text((response as RequestError).error),
              actions: [
                FilledButton(
                  onPressed: () {
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> search(ItemController itemController, String query) async {
    final RequestResult<List<GroceryListItemDisplay>> result =
        await itemController.searchItems(query);
    if (result is RequestSuccess<List<GroceryListItemDisplay>>) {
      if (mounted) {
        setState(() {
          searchIngredientsResults = result.result;
        });
      }
    } else {
      Fluttertoast.showToast(msg: (result as RequestError).error);
    }
  }

  void unSearch() {
    setState(() {
      searchIngredientsResults = List.empty();
    });
  }

  void showSelectImageSource() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 30,
              children: [
                IconButton(
                  onPressed: () => selectImage(context, ImageSource.gallery),
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo,
                        size: 60,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const Text("Gallery"),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => selectImage(context, ImageSource.camera),
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 60,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const Text("Camera"),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void selectImage(BuildContext context, ImageSource source) async {
    if (source == ImageSource.camera) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final fileBytes = await pickedFile.readAsBytes();
        if (context.mounted) {
          setState(() {
            imageBytes.add(fileBytes);
            imageViews.add(Image.memory(fileBytes));
          });
          Navigator.of(context).pop();
        }
      }
    } else {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final List<Uint8List> filesBytes = List.empty(growable: true);
        for (int i = 0; i < pickedFiles.length; i++) {
          final bytes = await pickedFiles[i].readAsBytes();
          filesBytes.add(bytes);
        }
        if (context.mounted) {
          setState(() {
            imageBytes.addAll(filesBytes);
            imageViews.addAll(filesBytes.map((e) => Image.memory(e)));
          });
          Navigator.of(context).pop();
        }
      }
    }
  }

  void removeItem(GroceryListItemDisplay item) {
    setState(() => ingredients.remove(item));
  }

  void addItem(GroceryListItemDisplay item) {
    setState(() => ingredients.add(item));
  }

  void incrementItem(GroceryListItemDisplay item) {
    setState(() {
      final index = ingredients.indexWhere((i) => i.id == item.id);
      ingredients[index] = GroceryListItemDisplay(
        id: item.id,
        name: item.name,
        quantity: item.quantity + 1,
        categoryId: item.categoryId,
        categoryName: item.categoryName,
      );
    });
  }

  void decrementItem(GroceryListItemDisplay item) {
    setState(() {
      final index = ingredients.indexWhere((i) => i.id == item.id);
      ingredients[index] = GroceryListItemDisplay(
        id: item.id,
        name: item.name,
        quantity: item.quantity - 1,
        categoryId: item.categoryId,
        categoryName: item.categoryName,
      );
    });
  }

  showCreateItem(ItemController controller) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(children: [TextFormField(), const Text("Test")]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as CreateRecipeArgs;
    final itemController = ItemController(jwt: args!.jwt);
    final recipeController = RecipeController(jwt: args!.jwt);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('New recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 0.95,
                    enlargeCenterPage: true,
                    aspectRatio: 3 / 2,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                  ),
                  items:
                      imageViews
                          .map<Widget>(
                            (e) => GestureDetector(
                              onTap:
                                  () => showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return GestureDetector(
                                        onTap: () => Navigator.of(ctx).pop(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: e,
                                        ),
                                      );
                                    },
                                  ),
                              child: e,
                            ),
                          )
                          .followedBy([
                            GestureDetector(
                              onTap: () => showSelectImageSource(),
                              child: Container(
                                constraints: BoxConstraints.tight(
                                  const Size.fromHeight(200),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer,
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate,
                                  size: 100,
                                ),
                              ),
                            ),
                          ])
                          .toList(),
                ),

                const SizedBox.square(dimension: 6),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: ShapeDecoration(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                    ),
                    // color:
                    // Theme.of(context).buttonTheme.colorScheme!.onSecondary,
                  ),
                  child: DotsIndicator(
                    dotsCount: imageBytes.length + 1,
                    position: currentPage.toDouble(),
                    onTap:
                        (position) =>
                            carouselController.animateToPage(position),

                    decorator: DotsDecorator(
                      activeColor: Theme.of(context).colorScheme.primary,
                      size: Size.square(6),
                      activeSize: Size.square(8),
                    ),
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: Column(
                spacing: 10,
                children: [
                  TextFormField(
                    validator: (item) {
                      if (item == null || item.isEmpty) {
                        return "Name should not be empty";
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Name",
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    validator: (item) {
                      if (item == null || item.isEmpty) {
                        return "Give a short description of the recipe.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Description",
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    validator: (item) {
                      if (item == null || item.isEmpty) {
                        return "A recipe needs instructions :)";
                      }
                      return null;
                    },
                    maxLines: 15,
                    minLines: 1,
                    controller: instructionsController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Instructions",
                    ),
                  ),

                  Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                      ),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children:
                          <Widget>[
                                Text(
                                  "Ingredients:",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: "Search",
                                          icon: Icon(Icons.search),
                                        ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            search(itemController, value);
                                          } else {
                                            unSearch();
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          "/create-recipe-item",
                                          arguments: args!.jwt,
                                        );
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ]
                              .followedBy(
                                searchIngredientsResults.isNotEmpty
                                    ? searchIngredientsResults
                                        .map<Widget>(
                                          (e) => SearchResultCard(
                                            info: e,
                                            onAdd: () {
                                              if (ingredients.any(
                                                (element) => element.id == e.id,
                                              )) {
                                                final i = ingredients
                                                    .indexWhere(
                                                      (element) =>
                                                          element.id == e.id,
                                                    );
                                                incrementItem(ingredients[i]);
                                              } else {
                                                addItem(e);
                                              }
                                              unSearch();
                                            },
                                          ),
                                        )
                                        .toList()
                                    : ingredients.isEmpty
                                    ? [
                                      const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          "You haven't selected any ingredients yet",
                                        ),
                                      ),
                                    ]
                                    : ingredients.map(
                                      (e) => IngredientCard(
                                        info: e,
                                        onDecrement: () => decrementItem(e),
                                        onIncrement: () => incrementItem(e),
                                        onRemove: () => removeItem(e),
                                      ),
                                    ),
                              )
                              .toList(),
                    ),
                  ),
                  canSubmit()
                      ? FilledButton(
                        onPressed: () => submit(recipeController),
                        child: const Text("Submit"),
                      )
                      : FilledButton(
                        onPressed: null,
                        child: const Text("Submit"),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
