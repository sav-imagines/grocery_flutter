import 'dart:typed_data';

import 'package:grocery_flutter/models/grocery_list_item_display.dart';

class CreateRecipeArgs {
  final List<Uint8List> imageBytes;
  final List<GroceryListItemDisplay> ingredients;

  const CreateRecipeArgs({required this.imageBytes, required this.ingredients});
}
