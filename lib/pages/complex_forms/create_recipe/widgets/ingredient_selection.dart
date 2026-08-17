import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/ingredient_card.dart';
import 'package:grocery_flutter/components/search_result_card.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';

class IngredientSelection extends StatelessWidget {
  final List<GroceryListItemDisplay> searchIngredientsResults;
  final List<GroceryListItemDisplay> selectedIngredients;
  final void Function(GroceryListItemDisplay) onAddItem;
  final void Function(GroceryListItemDisplay) onRemoveItem;
  final void Function(int) onDecrementItem;
  final void Function(int) onIncrementItem;

  const IngredientSelection({
    super.key,
    required this.searchIngredientsResults,
    required this.selectedIngredients,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onDecrementItem,
    required this.onIncrementItem,
  });

  @override
  Widget build(BuildContext context) {
    if (searchIngredientsResults.isNotEmpty)
      return Column(
        children:
            searchIngredientsResults
                .map<Widget>(
                  (e) => SearchResultCard(
                    info: e,
                    onAdd: () {
                      onAddItem(e);
                    },
                  ),
                )
                .toList(),
      );
    else if (selectedIngredients.isNotEmpty)
      return Column(
        children:
            selectedIngredients
                .mapIndexed(
                  (i, e) => IngredientCard(
                    info: e.toShortItem(),
                    onRemove: () => onRemoveItem(e),
                    onDecrement: () => onDecrementItem(i),
                    onIncrement: () => onIncrementItem(i),
                  ),
                )
                .toList(),
      );
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Text("You haven't selected any ingredients yet"),
    );
  }
}
