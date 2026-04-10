import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/models/full_recipe_model.dart';

class CreateListArgs {
  final List<CategoryModel> items;
  final List<FullRecipeModel> recipes;
  CreateListArgs(this.items, this.recipes);
}
