class GroceryListDisplay {
  GroceryListDisplay({
    required this.listId,
    required this.createdTime,
    required this.itemsCount,
  });

  final String listId;
  final DateTime createdTime;
  final int itemsCount;

  factory GroceryListDisplay.fromJson(Map<String, dynamic> item) {
    return GroceryListDisplay(
      listId: item['listId'] as String,
      createdTime: DateTime.parse(item['createdTime']),
      itemsCount: item['itemsCount'],
    );
  }
}
