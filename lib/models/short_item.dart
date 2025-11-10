class ShortItem {
  final String id;
  final String name;
  int quantity;

  ShortItem({required this.id, required this.name, this.quantity = 0});

  factory ShortItem.fromJson(Map<String, dynamic> json) {
    return ShortItem(id: json['id'], name: json['name']);
  }
}
