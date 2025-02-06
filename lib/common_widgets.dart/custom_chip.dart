import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomChip extends StatelessWidget {
  final Function()? onTap;
  final String name;
  const CustomChip({
    super.key,
    this.onTap,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: secondaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: secondaryColor,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
          ),
        ),
      ),
    );
  }
}
