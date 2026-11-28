import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_flutter/http/social/social_controller.dart';

// TODO: fix rebuild during navigation
class RedirectGroupPage extends ConsumerWidget {
  const RedirectGroupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getMyInfoProvider);

    if (userInfo.hasValue) {
      if (context.mounted) {
        if (userInfo.value!.isInGroup) {
          Navigator.of(context).popAndPushNamed('/home');
          return const Center(child: Text("Redirecting."));
        }
      } else {
        Navigator.of(context).popAndPushNamed('/received-invites');
        return const Center(child: Text("Redirecting."));
      }
    }
    return Scaffold(
      body: switch (userInfo) {
        AsyncData() => const Center(child: Text("Redirecting.")),
        AsyncError(:final error) => ErrorWidget(error),
        AsyncLoading() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
            SizedBox.square(dimension: 10),
            const Text("Fetching group info..."),
          ],
        ),
      },
    );
  }
}
