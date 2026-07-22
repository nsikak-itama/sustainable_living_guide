import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Draws the 3-segment donut chart showing Travel/Home/Food
/// proportions of today's total footprint, with the total kg CO2e
/// value centered inside the ring.
class FootprintRingChart extends StatelessWidget {
  final double travelKgCo2e;
  final double homeKgCo2e;
  final double foodKgCo2e;

  const FootprintRingChart({
    super.key,
    required this.travelKgCo2e,
    required this.homeKgCo2e,
    required this.foodKgCo2e,
  });

  static const travelColor = Color(0xFF0B2B13); // dark green
  static const homeColor = Color(0xFF4A6B52); // muted green
  static const foodColor = Color(0xFFE8B87A); // tan/orange
  static const trackColor = Color(0xFFE0E0DA); // light gray track

  double get total => travelKgCo2e + homeKgCo2e + foodKgCo2e;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: _RingPainter(
              travel: travelKgCo2e,
              home: homeKgCo2e,
              food: foodKgCo2e,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                total.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: travelColor,
                ),
              ),
              const Text(
                'KG CO₂E',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double travel;
  final double home;
  final double food;

  _RingPainter({required this.travel, required this.home, required this.food});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 24.0;

    final total = travel + home + food;

    final trackPaint = Paint()
      ..color = FootprintRingChart.trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Background track (shows even if total is 0).
    canvas.drawCircle(
      center,
      radius - strokeWidth / 2,
      trackPaint,
    );

    if (total <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);
    double startAngle = -math.pi / 2; // start at top

    final segments = [
      _Segment(travel, FootprintRingChart.travelColor),
      _Segment(home, FootprintRingChart.homeColor),
      _Segment(food, FootprintRingChart.foodColor),
    ];

    for (final segment in segments) {
      if (segment.value <= 0) continue;
      final sweep = (segment.value / total) * 2 * math.pi;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.travel != travel ||
        oldDelegate.home != home ||
        oldDelegate.food != food;
  }
}

class _Segment {
  final double value;
  final Color color;
  _Segment(this.value, this.color);
}