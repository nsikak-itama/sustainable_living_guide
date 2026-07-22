import 'package:flutter/material.dart';

/// A simple completion congratulations message — no badge icon or
/// collectible graphic, per our scope decision. Shown only when the
/// user has at least one completed challenge.
class AchievementBanner extends StatelessWidget {
  final String challengeTitle;

  const AchievementBanner({super.key, required this.challengeTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF0B2B13), size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Challenge Completed!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  "You've completed \"$challengeTitle\". Great work!",
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}