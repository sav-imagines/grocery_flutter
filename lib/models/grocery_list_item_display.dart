import 'package:grocery_flutter/models/short_item.dart';

class GroceryListItemDisplay {
  final String id;
  final String name;
  final int quantity;
  final String categoryId;
  final String categoryName;

  GroceryListItemDisplay({
    required this.id,
    required this.name,
    required this.quantity,
    required this.categoryId,
    required this.categoryName,
  });

  factory GroceryListItemDisplay.fromJson(Map<String, dynamic> item) {
    return GroceryListItemDisplay(
      id: item['id'],
      name: item['name'],
      quantity: item['quantity'],
      categoryId: item['categoryId'],
      categoryName: item['categoryName'],
    );
  }

  GroceryListItemDisplay copyWith({
    String? id,
    String? name,
    int? quantity,
    String? categoryId,
    String? categoryName,
  }) {
    return GroceryListItemDisplay(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Map<String, dynamic> toJson() {
    return Map.from({"ItemId": id, "Quantity": quantity});
  }

  ShortItem toShortItem() {
    return ShortItem(id: id, name: name, quantity: quantity);
  }
}
