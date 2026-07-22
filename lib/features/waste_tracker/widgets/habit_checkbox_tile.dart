import 'package:flutter/material.dart';

/// A habit row with an icon-in-circle on the left and a checkbox
/// on the right — matches the design's "Daily Waste Habits" rows.
class HabitCheckboxTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool checked;
  final VoidCallback onTap;

  const HabitCheckboxTile({
    super.key,
    required this.icon,
    required this.label,
    required this.checked,
    required this.onTap,
  });

  static const darkGreen = Color(0xFF0B2B13);
  static const iconBg = Color(0xFFC9E4CB);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: checked ? darkGreen : const Color(0xFFDDDDD5),
            width: checked ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: darkGreen, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14)),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: checked ? darkGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: checked ? darkGreen : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: checked
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}