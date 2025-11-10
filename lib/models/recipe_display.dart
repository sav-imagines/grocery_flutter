import 'dart:typed_data';
import 'package:grocery_flutter/models/recipe_info.dart';

class RecipeDisplay {
  final RecipeInfo info;
  Uint8List? imageBytes;

  RecipeDisplay({required this.info, required this.imageBytes});
}
