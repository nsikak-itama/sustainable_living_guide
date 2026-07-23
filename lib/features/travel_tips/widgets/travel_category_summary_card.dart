import 'package:flutter/material.dart';

class TravelCategorySummaryCard extends StatelessWidget {
  final String title;
  final int tipCount;
  final bool selected;
  final VoidCallback onTap;

  const TravelCategorySummaryCard({
    super.key,
    required this.title,
    required this.tipCount,
    required this.selected,
    required this.onTap,
  });

  static const darkGreen = Color(0xFF0B2B13);
  static const iconBg = Color(0xFFC9E4CB);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? darkGreen : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_car_outlined, color: darkGreen, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '$tipCount tip${tipCount == 1 ? '' : 's'}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}