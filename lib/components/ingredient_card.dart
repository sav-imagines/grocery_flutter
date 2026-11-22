import 'package:flutter/material.dart';
import 'package:grocery_flutter/models/short_item.dart';

class IngredientCard extends StatelessWidget {
  final ShortItem info;
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
    bool showsDeletionIcon = info.quantity <= 0 && onRemove != null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
                color:
                    showsDeletionIcon
                        ? Theme.of(context).colorScheme.error
                        : null,
                iconSize: 20,
                padding: EdgeInsets.zero,
                onPressed: info.quantity > 0 ? onDecrement : onRemove,
                icon:
                    showsDeletionIcon
                        ? (const Icon(Icons.delete_outline))
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
              Expanded(
                child: Text(
                  info.name,
                  maxLines: 1,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
