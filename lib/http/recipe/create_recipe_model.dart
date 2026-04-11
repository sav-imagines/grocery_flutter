import 'dart:convert';
import 'dart:typed_data';

import 'package:grocery_flutter/models/grocery_list_item_display.dart';

class CreateRecipeModel {
  final String name;
  final String description;
  final String instructions;
  final List<Uint8List> pictures;
  final List<GroceryListItemDisplay> items;

  CreateRecipeModel({
    required this.name,
    required this.description,
    required this.instructions,
    required this.pictures,
    required this.items,
  });

  Iterable<MapEntry<String, String>> toStringMap() {
    return [
      MapEntry("Name", name),
      MapEntry("Description", description),
      MapEntry("Steps", instructions),
      MapEntry(
        "Items",
        jsonEncode(items.map((item) => item.toJson()).toList()),
      ),
    ];
  }
}
