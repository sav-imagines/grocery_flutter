import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_flutter/http/recipe/recipe_controller.dart';
import 'package:grocery_flutter/pages/complex_forms/create_recipe/create_recipe_args.dart';
import 'package:grocery_flutter/components/recipe_list_card.dart';

class RecipesPage extends ConsumerWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(getAllRecipesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed:
            () => Navigator.of(context).pushNamed(
              "/create-recipe",
              arguments: CreateRecipeArgs(
                imageBytes: List.empty(growable: true),
                ingredients: List.empty(growable: true),
              ),
            ),
      ),
      body: switch (recipes) {
        AsyncValue(:final value?) => RefreshIndicator(
          onRefresh: () async {
            // TODO: invalidate cache
          },
          child:
              value.isEmpty
                  ? const Center(child: Text("You don't have any recipes"))
                  : ListView.separated(
                    padding: const EdgeInsets.all(5),
                    separatorBuilder:
                        (c, i) => const SizedBox.square(dimension: 10),
                    itemCount: value.length,

                    itemBuilder: (context, index) {
                      final item = value[index];
                      return RecipeListCard(info: item, onTap: () => {});
                    },
                  ),
        ),
        AsyncValue(error: != null) => Text('Error: ${recipes.error}'),
        AsyncValue() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
