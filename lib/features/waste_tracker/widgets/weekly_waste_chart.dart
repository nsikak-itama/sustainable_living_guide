import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../model/waste_log_model.dart';

/// Grouped bar chart showing Landfill/Recycling/Organic kg for
/// each of the last 7 days, labeled with the actual weekday of
/// each log's date (not a fixed Mon-Sun assumption).
class WeeklyWasteChart extends StatelessWidget {
  final List<WasteLog> logs; // exactly 7, oldest to newest

  const WeeklyWasteChart({super.key, required this.logs});

  static const landfillColor = Color(0xFF8A6E4B); // brown
  static const recyclingColor = Color(0xFF0B2B13); // dark green
  static const organicColor = Color(0xFFE8B87A); // tan

  double get _maxY {
    double max = 1;
    for (final log in logs) {
      final total = [log.landfillKg, log.recyclingKg, log.organicKg]
          .reduce((a, b) => a > b ? a : b);
      if (total > max) max = total;
    }
    return max * 1.2; // headroom above tallest bar
  }

  /// Parses a log's "yyyy-MM-dd" date string and returns its
  /// 3-letter weekday abbreviation, e.g. "Wed".
  String _weekdayLabel(String dateString) {
    final date = DateFormat('yyyy-MM-dd').parse(dateString);
    return DateFormat('E').format(date); // "Mon", "Tue", etc.
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: _maxY,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= logs.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _weekdayLabel(logs[index].date),
                      style: const TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(logs.length, (index) {
            final log = logs[index];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(toY: log.landfillKg, color: landfillColor, width: 6),
                BarChartRodData(toY: log.recyclingKg, color: recyclingColor, width: 6),
                BarChartRodData(toY: log.organicKg, color: organicColor, width: 6),
              ],
              barsSpace: 3,
            );
          }),
        ),
      ),
    );
  }
}