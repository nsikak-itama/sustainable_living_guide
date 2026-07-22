import 'package:flutter/material.dart';

/// A single checkbox row for the label-type filter section —
/// icon, title, and a checkbox on the right. Multi-select.
class LabelTypeFilterTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool checked;
  final VoidCallback onTap;

  const LabelTypeFilterTile({
    super.key,
    required this.icon,
    required this.label,
    required this.checked,
    required this.onTap,
  });

  static const darkGreen = Color(0xFF0B2B13);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: checked ? darkGreen : const Color(0xFFDDDDD5),
            width: checked ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: darkGreen),
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