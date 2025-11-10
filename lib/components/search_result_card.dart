import 'package:flutter/material.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';

class SearchResultCard extends StatelessWidget {
  final GroceryListItemDisplay info;
  final void Function()? onAdd;

  const SearchResultCard({super.key, required this.info, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
      ),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
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
