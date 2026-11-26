import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_flutter/http/recipe/recipe_controller.dart';
import 'package:grocery_flutter/models/recipe_info.dart';

class RecipeListCard extends ConsumerWidget {
  final RecipeInfo info;
  final void Function()? onTap;

  const RecipeListCard({super.key, required this.info, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Uint8List>? image = null;
    if (info.pictureName != null)
      image = ref.watch(getPictureProvider(info.pictureName!));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          color: Theme.of(context).buttonTheme.colorScheme!.onSecondary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            spacing: 20,
            children: <Widget>[
              switch (image) {
                null => (const Icon(Icons.image, size: 90)),
                AsyncData(:final value) => ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  clipBehavior: Clip.hardEdge,
                  child: Image.memory(value, width: 90, height: 90),
                ),
                AsyncError() => const Icon(Icons.broken_image, size: 90),
                AsyncValue() => (const Icon(Icons.image, size: 90)),
              },
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   child:
                    Text(
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      maxLines: 2,
                      info.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(info.description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
