import 'package:flutter/material.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';

class IngredientCard extends StatelessWidget {
  final GroceryListItemDisplay info;
  final void Function()? onIncrement;
  final void Function()? onDecrement;
  final void Function()? onRemove;

  const IngredientCard({
    super.key,
    required this.info,
    required this.onDecrement,
    required this.onIncrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
        // color: Theme.of(context).buttonTheme.colorScheme!.onSecondary,
      ),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          onDecrement == null && onRemove == null
              ? SizedBox.shrink()
              : (info.quantity < 2
                  ? IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete),
                  )
                  : IconButton(
                    onPressed: onDecrement,
                    icon: const Icon(Icons.remove),
                  )),
          Text(
            info.quantity.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          IconButton(onPressed: onIncrement, icon: const Icon(Icons.add)),
          // SizedBox.fromSize(size: Size(15, 1)),
          Text(
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            info.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
