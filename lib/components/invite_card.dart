import 'package:flutter/material.dart';
import 'package:grocery_flutter/http/social/invite.dart';

class InviteCard extends StatelessWidget {
  final Invite invite;
  final void Function()? onAccept;
  final void Function()? onReject;

  const InviteCard({
    super.key,
    required this.invite,
    required this.onAccept,
    required this.onReject,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            invite.groupName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text('Invited at ${invite.createdAt}'),
          Text('Expires at ${invite.expiresAt}'),
          Text('Group has ${invite.groupMemberCount} members'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(onPressed: onAccept, child: Text('Accept')),
              FilledButton(onPressed: onReject, child: Text('Reject')),
            ],
          ),
        ],
      ),
    );
  }
}
