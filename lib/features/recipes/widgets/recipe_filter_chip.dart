import 'package:flutter/material.dart';

/// A single-select filter chip, matching the design's rounded
/// pill style — filled dark green when selected, gray otherwise.
class RecipeFilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const RecipeFilterChipWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const darkGreen = Color(0xFF0B2B13);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? darkGreen : const Color(0xFFE5E4DC),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}