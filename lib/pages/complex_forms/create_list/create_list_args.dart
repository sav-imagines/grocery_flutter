import 'package:grocery_flutter/models/category_model.dart';

class CreateListArgs {
  final String jwt;
  final List<CategoryModel>? items;
  final int index;

  CreateListArgs({required this.jwt, required this.items, this.index = 0});
}
