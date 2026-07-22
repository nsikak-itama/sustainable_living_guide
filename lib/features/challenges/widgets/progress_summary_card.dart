import 'package:flutter/material.dart';

/// The "Your Progress" header card — active challenge count and
/// total CO2 saved. No Level/XP, per our scope decision.
class ProgressSummaryCard extends StatelessWidget {
  final int activeCount;
  final double totalCo2SavedKg;

  const ProgressSummaryCard({
    super.key,
    required this.activeCount,
    required this.totalCo2SavedKg,
  });

  static const darkGreen = Color(0xFF0B2B13);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ACTIVE CHALLENGES',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$activeCount ongoing',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'CO2 SAVED',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${totalCo2SavedKg.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}