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
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(indent: 15, endIndent: 15),
          Text(category.name, style: TextTheme.of(context).titleSmall),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var item in category.items)
                IconButton(
                  iconSize: 20,
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    foregroundColor: WidgetStatePropertyAll(
                      theme.colorScheme.onSurface,
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      item.quantity <= 0
                          ? theme.colorScheme.surface
                          : theme.colorScheme.primaryContainer,
                    ),
                  ),
                  onPressed: () => onIncrement(item.id),
                  icon: Row(
                    children: [
                      IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        onPressed:
                            item.quantity > 0
                                ? () => onDecrement(item.id)
                                : null,
                        icon:
                            item.quantity <= 1
                                ? const Icon(Icons.delete)
                                : const Icon(Icons.remove),
                      ),
                      SizedBox(
                        width: 20,
                        child: Text(
                          item.quantity.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
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
