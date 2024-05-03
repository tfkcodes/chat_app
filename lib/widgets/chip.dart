import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';

class IChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final String? img;
  final VoidCallback onTap;

  const IChip(
      {super.key,
      required this.label,
      required this.isSelected,
      required this.onTap,
      this.img});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ChoiceChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.onBackground,
        ),
        selected: isSelected,
        onSelected: (selected) {
          onTap();
        },
        selectedColor: AppColors.primaryColor400,
      ),
    );
  }
}
