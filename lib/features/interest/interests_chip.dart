import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class InterestsChip extends StatefulWidget {
  final Function(bool isActive)? onTap;
  final bool isActive;
  final String name;
  const InterestsChip({
    super.key,
    this.onTap,
    required this.name,
    required this.isActive,
  });

  @override
  State<InterestsChip> createState() => _InterestsChipState();
}

class _InterestsChipState extends State<InterestsChip> {
  bool isActive = true;

  @override
  void initState() {
    isActive = widget.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? primaryColor : secondaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: secondaryColor,
        ),
      ),
      child: InkWell(
        onTap: () {
          isActive = !isActive;
          setState(() {});
          widget.onTap!(isActive);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Text(
            widget.name,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : Colors.black,
                ),
          ),
        ),
      ),
    );
  }
}
