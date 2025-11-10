import 'package:flutter/material.dart';
import 'package:grocery_flutter/models/short_item.dart';

class CategoryView extends StatelessWidget {
  final List<ShortItem> items;
  final void Function(ShortItem, int) changeQuantity;

  const CategoryView({
    super.key,
    required this.items,
    required this.changeQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8,
      children:
          items.isEmpty
              ? const [Text("There are no items in this category")]
              : items
                  .map<Widget>(
                    (item) => Container(
                      decoration: ShapeDecoration(
                        color:
                            item.quantity == 0
                                ? Theme.of(context).colorScheme.onSecondary
                                : (item.quantity == 1
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.secondaryContainer
                                    : Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: Row(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                            ),
                            onPressed:
                                item.quantity > 0
                                    ? () {
                                      changeQuantity(item, item.quantity - 1);
                                    }
                                    : null,
                            icon: Icon(
                              Icons.remove,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),

                          Text(
                            item.quantity.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () {
                              changeQuantity(item, item.quantity + 1);
                            },
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              item.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
    );
  }
}
