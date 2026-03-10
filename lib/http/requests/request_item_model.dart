import 'package:grocery_flutter/models/short_item.dart';

class RequestItemModel {
  late final String id;
  late final int quantity;

  RequestItemModel({required this.id, required this.quantity});

  factory RequestItemModel.fromShortItem(ShortItem item) {
    return RequestItemModel(id: item.id, quantity: item.quantity);
  }

  String toJson() {
    return '{"ItemId": "$id", "Quantity": $quantity}';
  }
}
