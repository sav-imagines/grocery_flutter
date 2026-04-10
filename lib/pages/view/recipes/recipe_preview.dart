import 'package:flutter/material.dart';
import 'package:grocery_flutter/models/recipe_display.dart';
import 'package:grocery_flutter/models/short_item.dart';

WidgetBuilder recipePreview(RecipeDisplay item, List<ShortItem>? ingredients) =>
    ((BuildContext context) => DraggableScrollableSheet(
      maxChildSize: 0.6,
      initialChildSize: 0.6,
      expand: false,
      builder:
          (context, scrollController) => Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  // fill full width of modal bottom sheet
                  mainAxisSize: MainAxisSize.max,
                  children: [SizedBox.shrink()],
                ),
                item.imageBytes != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.hardEdge,
                      child: Image.memory(width: 200, item.imageBytes!),
                    )
                    : const Text("No image was detected???"),
                Text(
                  item.info.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  item.info.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ingredients == null
                    ? Center(child: Text("Could not fetch ingredients"))
                    : Expanded(
                      child: ListView(
                        children:
                            ingredients
                                .map(
                                  (ingredient) => Row(
                                    children:
                                        [
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              ingredient.quantity.toString(),
                                            ),
                                          ),
                                          Text(ingredient.name),
                                        ].toList(),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
              ],
            ),
          ),
    ));
