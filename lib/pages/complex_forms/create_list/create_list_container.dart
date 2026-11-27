import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_flutter/http/item/item_controller.dart';
import 'package:grocery_flutter/http/recipe/recipe_controller.dart';
import 'package:grocery_flutter/http/requests/request_controller.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/models/full_recipe_model.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_page.dart';

class CreateListContainer extends ConsumerWidget {
  const CreateListContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<CategoryModel>> items = ref.watch(
      getItemsInGroupProvider,
    );
    final AsyncValue<List<ShortItem>> requests = ref.watch(
      getRequestedItemsProvider,
    );
    final AsyncValue<List<FullRecipeModel>> recipes = ref.watch(
      getFullRecipeModelsProvider,
    );
    if (items.hasValue && requests.hasValue && recipes.hasValue) {
      return CreateListPage(
        categories: items.value!,
        requests: requests.value!,
        recipes: recipes.value!,
      );
    } else if (items.isLoading || requests.isLoading || recipes.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (items.hasError) {
      return ErrorWidget(Exception(items.error));
    } else if (requests.hasError) {
      return ErrorWidget(Exception(requests.error));
    } else if (recipes.hasError) {
      return ErrorWidget(Exception(recipes.error));
    } else {
      return ErrorWidget(Exception("Programming error"));
    }
  }
}
