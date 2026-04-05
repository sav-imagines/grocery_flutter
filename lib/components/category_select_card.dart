import 'package:flutter/material.dart';
import 'package:grocery_flutter/components/ingredient_card.dart';
import 'package:grocery_flutter/models/category_model.dart';

class CategorySelectCard extends StatelessWidget {
  final CategoryModel category;
  final void Function(String id) onDecrement;
  final void Function(String id) onIncrement;
  final void Function() onCreateItem;

  const CategorySelectCard({
    super.key,
    required this.category,
    required this.onDecrement,
    required this.onIncrement,
    required this.onCreateItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Text(category.name, style: TextTheme.of(context).titleMedium),
          SizedBox.square(dimension: 10),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var item in category.items)
                IngredientCard(
                  info: item,
                  onDecrement: () => onDecrement(item.id),
                  onIncrement: () => onIncrement(item.id),
                  onRemove: null,
                ),
              IconButton(
                onPressed: onCreateItem,
                icon: Row(
                  spacing: 10,
                  children: [Icon(Icons.add), Text("New item")],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
