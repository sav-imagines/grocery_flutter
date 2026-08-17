import 'package:flutter/material.dart';

class ImageSourceButton extends StatelessWidget {
  const ImageSourceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSecondaryContainer;

    return IconButton(
      onPressed: onPressed,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 60, color: color), Text(label)],
      ),
    );
  }
}
