import 'package:grocery_flutter/models/recipe_info.dart';
import 'package:grocery_flutter/models/short_item.dart';

class FullRecipeModel {
  RecipeInfo recipe;
  List<ShortItem>? items;
  int quantity;

  FullRecipeModel({
    required this.recipe,
    required this.items,
    this.quantity = 0,
  });

  factory FullRecipeModel.fromJson(Map<String, dynamic> json) {
    List items = json['items'] as List;
    return FullRecipeModel(
      recipe: RecipeInfo.fromJson(json['recipe']),
      items: items.map((item) => ShortItem.fromJson(item)).toList(),
    );
  }

  changeQuantity(ShortItem item, int quantity) {
    if (!(items?.any((existingItem) => existingItem.id == item.id) ?? false)) {
      return;
    }
    ShortItem foundItem = items!.firstWhere((e) => e.id == item.id);
    foundItem.quantity = quantity;
  }
}
