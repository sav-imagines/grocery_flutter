import 'package:flutter/material.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Text(category.name, style: TextTheme.of(context).titleSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var item in category.items)
                IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  onPressed: () => onIncrement(item.id),
                  icon: Row(
                    children: [
                      IconButton(
                        onPressed:
                            item.quantity >= 0
                                ? () => onDecrement(item.id)
                                : null,
                        icon: Icon(Icons.remove),
                      ),
                      SizedBox(
                        width: 20,
                        child: Text(item.quantity.toString()),
                      ),
                      IconButton(
                        onPressed: () => onIncrement(item.id),
                        icon: Icon(Icons.add),
                      ),
                      Text(item.name),
                    ],
                  ),
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
