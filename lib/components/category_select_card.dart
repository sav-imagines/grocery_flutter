import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/models/category_model.dart';

class CategorySelectCard extends StatelessWidget {
  final CategoryModel category;
  final void Function()? onDecrement;
  final void Function()? onIncrement;
  const CategorySelectCard({
    super.key,
    required this.category,
    required this.onDecrement,
    required this.onIncrement,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              for (var item in category.items)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      style: ButtonStyle(),

                      onPressed: onDecrement,
                      icon: Icon(Icons.remove),
                    ),
                    Text(item.quantity.toString()),
                    IconButton(
                      onPressed: () {
                        Fluttertoast.showToast(msg: item.quantity.toString());
                      },
                      icon: Icon(Icons.add),
                    ),
                    Text(item.name),
                  ],
                ),
              IconButton(
                onPressed: () {},
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
