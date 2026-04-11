import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';

class EditCategoryArgs {
  final CreateListArgs state;
  final CategoryModel category;

  EditCategoryArgs(this.state, this.category);
}
