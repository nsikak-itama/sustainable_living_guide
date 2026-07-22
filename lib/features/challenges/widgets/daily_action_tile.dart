import 'package:flutter/material.dart';

/// A single row in "Daily Actions" — shows a challenge's check-in
/// status for today. Tapping the checkbox triggers a check-in,
/// unless already checked in today (disabled state).
class DailyActionTile extends StatelessWidget {
  final String title;
  final int daysCompleted;
  final int durationDays;
  final bool checkedInToday;
  final VoidCallback onCheckIn;

  const DailyActionTile({
    super.key,
    required this.title,
    required this.daysCompleted,
    required this.durationDays,
    required this.checkedInToday,
    required this.onCheckIn,
  });

  static const darkGreen = Color(0xFF0B2B13);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: checkedInToday ? darkGreen : Colors.grey.shade300,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checkedInToday
                      ? 'Completed Day $daysCompleted of "$title"'
                      : 'Check in on "$title"',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Challenge progress: $daysCompleted/$durationDays days',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: checkedInToday ? null : onCheckIn,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: checkedInToday ? darkGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: checkedInToday ? darkGreen : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: checkedInToday
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}