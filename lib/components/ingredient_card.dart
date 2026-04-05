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
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
        // color: Theme.of(context).buttonTheme.colorScheme!.onSecondary,
      ),
      child: GestureDetector(
        onTap: switch (info.quantity) {
          0 => () => onIncrement!(),
          1 => () => onDecrement!(),
          _ => null,
        },
        child: Container(
          decoration: BoxDecoration(
            color:
                info.quantity <= 0
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
                onPressed: info.quantity > 0 ? () => onDecrement!() : null,
                icon:
                    info.quantity <= 1
                        ? const Icon(Icons.delete_outline)
                        : const Icon(Icons.remove),
              ),
              SizedBox(
                width: 20,
                child: Text(
                  info.quantity.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                iconSize: 20,
                padding: EdgeInsets.zero,
                onPressed: () => onIncrement!(),
                icon: Icon(Icons.add),
              ),
              Text(info.name),
            ],
          ),
        ),
      ),
    );
  }
}
