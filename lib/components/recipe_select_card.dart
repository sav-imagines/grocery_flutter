import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/ingredient_card.dart';
import 'package:grocery_flutter/models/full_recipe_model.dart';
import 'package:grocery_flutter/models/short_item.dart';

class RecipeSelectCard extends StatelessWidget {
  final List<FullRecipeModel> recipes;
  final void Function(String id) onDecrement;
  final void Function(String id) onIncrement;

  const RecipeSelectCard({
    super.key,
    required this.recipes,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Text("Recipes", style: TextTheme.of(context).titleMedium),
          SizedBox.square(dimension: 10),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipes.isEmpty)
                IconButton(
                  onPressed: null,
                  icon: Row(
                    spacing: 10,
                    children: [Icon(Icons.add), Text("No recipes")],
                  ),
                )
              else
                for (var item in recipes)
                  IngredientCard(
                    info: ShortItem(
                      id: "",
                      name: item.recipe.name,
                      quantity: item.quantity,
                    ),
                    onDecrement: () => onDecrement(item.recipe.id),
                    onIncrement: () => onIncrement(item.recipe.id),
                    onRemove: null,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
