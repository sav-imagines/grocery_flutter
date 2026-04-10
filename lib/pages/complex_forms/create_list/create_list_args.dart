import 'package:grocery_flutter/models/category_model.dart';

class CreateListArgs {
  final List<CategoryModel>? items;
  final int index;

  CreateListArgs({required this.items, this.index = 0});
}
