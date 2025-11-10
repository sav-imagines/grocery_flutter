// import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:grocery_flutter/models/grocery_list_display.dart';

class GroceryListCard extends StatelessWidget {
  final GroceryListDisplay info;
  final void Function()? onTap;

  const GroceryListCard({super.key, required this.info, required this.onTap});

  static String getDescription(Duration timeDelta) {
    if (timeDelta.inDays > 365) {
      return '${(timeDelta.inDays / 365).floor()} year${(timeDelta.inDays / 365).floor() > 1 ? "s" : ""} ago';
    } else if (timeDelta.inDays > 0) {
      return '${timeDelta.inDays} day${timeDelta.inDays > 1 ? "s" : ""} ago';
    } else if (timeDelta.inHours > 0) {
      return '${timeDelta.inHours} hour${timeDelta.inHours > 1 ? "s" : ""} ago';
    } else if (timeDelta.inMinutes > 0) {
      return '${timeDelta.inMinutes} minute${timeDelta.inMinutes > 1 ? "s" : ""} ago';
    } else {
      return '${timeDelta.inSeconds} second${timeDelta.inSeconds > 1 ? "s" : ""} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11)),
          ),
          color: Theme.of(context).buttonTheme.colorScheme!.onSecondary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            badges.Badge(
              position: badges.BadgePosition.bottomEnd(bottom: -9, end: -7),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              badgeContent: Text(
                info.itemsCount.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 20,
                ),
              ),
              child: const Icon(Icons.shopping_cart, size: 64),
            ),
            SizedBox.square(dimension: 12),
            Text(getDescription(DateTime.now().difference(info.createdTime))),
          ],
        ),
      ),
    );
  }
}
