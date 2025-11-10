import 'package:flutter/material.dart';
import 'package:grocery_flutter/http/social/user_info.dart';

class PersonCard extends StatelessWidget {
  final UserInfo userInfo;
  final GestureTapCallback onTap;
  final bool isOwner;
  const PersonCard({
    super.key,
    required this.userInfo,
    required this.onTap,
    this.isOwner = false,
  });
  static String getDescription(Duration timeDelta) {
    if (timeDelta.inDays > 1) {
      return '${timeDelta.inDays - 1} days ago';
    } else if (timeDelta.inHours > 1) {
      return '${timeDelta.inHours} hours ago';
    } else if (timeDelta.inMinutes > 1) {
      return '${timeDelta.inMinutes} minutes ago';
    } else {
      return '${timeDelta.inSeconds} seconds ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11)),
          ),
          color: Theme.of(context).buttonTheme.colorScheme!.onSecondary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              (isOwner || !userInfo.isInGroup
                  ? Icons.person
                  : Icons.person_outline),
              size: 100,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  userInfo.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Joined ${getDescription(DateTime.now().difference(userInfo.joinedAt))}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
