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
      padding: EdgeInsets.symmetric(horizontal: 10),
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
                GestureDetector(
                  onTap: switch (item.quantity) {
                    0 => () => onIncrement(item.id),
                    1 => () => onDecrement(item.id),
                    _ => null,
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          item.quantity <= 0
                              ? theme.colorScheme.surface
                              : theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
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
                                  ? const Icon(Icons.delete_outline)
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
