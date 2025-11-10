import 'package:flutter/material.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';

class ItemCard extends StatelessWidget {
  final GroceryListItemDisplay info;
  const ItemCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
        color: Theme.of(context).buttonTheme.colorScheme!.onSecondary,
      ),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            info.quantity.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox.fromSize(size: Size(15, 1)),
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
