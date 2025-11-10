import 'package:flutter/material.dart';
import 'package:grocery_flutter/http/social/invite.dart';

class InvitedPersonCard extends StatelessWidget {
  final Invite invite;
  final void Function()? onRetract;

  const InvitedPersonCard({
    super.key,
    required this.invite,
    required this.onRetract,
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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                invite.userName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Text('Invited at ${invite.createdAt}'),
              ),
              Text('Expires at ${invite.expiresAt}'),
              FilledButton(onPressed: onRetract, child: const Text("Uninvite")),
            ],
          ),
        ],
      ),
    );
  }
}
