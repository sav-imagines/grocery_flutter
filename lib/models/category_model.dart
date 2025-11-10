import 'package:grocery_flutter/models/short_item.dart';

class CategoryModel {
  final String id;
  final String name;
  List<ShortItem> items;

  CategoryModel({required this.id, required this.name, required this.items});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List items = json['items'] as List;
    return CategoryModel(
      id: json['id'],
      name: json['categoryName'],
      items: items.map((item) => ShortItem.fromJson(item)).toList(),
    );
  }

  changeQuantity(ShortItem item, int quantity) {
    if (!items.any((existingItem) => existingItem.id == item.id)) {
      return;
    }
    ShortItem foundItem = items.firstWhere((e) => e.id == item.id);
    foundItem.quantity = quantity;
  }
}
