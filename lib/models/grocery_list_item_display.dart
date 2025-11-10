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

  Map<String, dynamic> toJson() {
    return Map.from({"ItemId": id, "Quantity": quantity});
  }
}
