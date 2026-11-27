import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/ingredient_card.dart';
import 'package:grocery_flutter/models/full_recipe_model.dart';
import 'package:grocery_flutter/models/short_item.dart';

class RecipeSelectCard extends StatelessWidget {
  final List<FullRecipeModel> recipes;
  final void Function(int idx) onDecrement;
  final void Function(int idx) onIncrement;

  const RecipeSelectCard({
    super.key,
    required this.recipes,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            title: Text("Recipes", style: TextTheme.of(context).titleMedium),
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
                for (var (item, idx) in Iterable.generate(
                  recipes.length,
                  (idx) => (recipes[idx], idx),
                ))
                  IngredientCard(
                    info: ShortItem(
                      id: "",
                      name: item.recipe.name,
                      quantity: item.quantity,
                    ),
                    onDecrement: () => onDecrement(idx),
                    onIncrement: () => onIncrement(idx),
                    onRemove: null,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
