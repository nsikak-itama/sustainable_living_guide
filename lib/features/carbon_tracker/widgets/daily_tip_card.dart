import 'package:flutter/material.dart';
import '../provider/daily_tips_provider.dart';

/// Renders a single tip card with a colored left border, icon,
/// title, and description — matching the design's tip cards.
class DailyTipCardWidget extends StatelessWidget {
  final DailyTip tip;

  const DailyTipCardWidget({super.key, required this.tip});

  IconData get _icon {
    switch (tip.iconKey) {
      case 'lightbulb':
        return Icons.lightbulb_outline;
      case 'leaf':
        return Icons.eco_outlined;
      case 'bike':
        return Icons.directions_bike_outlined;
      case 'bus':
        return Icons.directions_bus_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color get _accentColor {
    switch (tip.iconKey) {
      case 'bike':
        return const Color(0xFFE8B87A); // tan, matches "Short Distances" in design
      default:
        return const Color(0xFF0B2B13); // dark green
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: accent, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, color: accent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.description,
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