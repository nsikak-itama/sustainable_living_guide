import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single day's carbon footprint log for a user.
/// Each category (travel, home, food) stores the list of activity
/// keys the user checked off, plus the calculated kg CO2e for that
/// category and the overall total.
class CarbonLog {
  final String date; // e.g. "2024-03-24", also used as the Firestore doc ID
  final List<String> travel;
  final List<String> home;
  final List<String> food;
  final double travelKgCo2e;
  final double homeKgCo2e;
  final double foodKgCo2e;
  final double totalKgCo2e;
  final DateTime updatedAt;

  CarbonLog({
    required this.date,
    required this.travel,
    required this.home,
    required this.food,
    required this.travelKgCo2e,
    required this.homeKgCo2e,
    required this.foodKgCo2e,
    required this.totalKgCo2e,
    required this.updatedAt,
  });

  /// An empty log for a given date — used when the user hasn't
  /// logged anything yet today.
  factory CarbonLog.empty(String date) {
    return CarbonLog(
      date: date,
      travel: [],
      home: [],
      food: [],
      travelKgCo2e: 0,
      homeKgCo2e: 0,
      foodKgCo2e: 0,
      totalKgCo2e: 0,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'travel': travel,
      'home': home,
      'food': food,
      'travelKgCo2e': travelKgCo2e,
      'homeKgCo2e': homeKgCo2e,
      'foodKgCo2e': foodKgCo2e,
      'totalKgCo2e': totalKgCo2e,
      'updatedAt': updatedAt,
    };
  }

  factory CarbonLog.fromMap(Map<String, dynamic> map) {
    return CarbonLog(
      date: map['date'] as String,
      travel: List<String>.from(map['travel'] as List? ?? []),
      home: List<String>.from(map['home'] as List? ?? []),
      food: List<String>.from(map['food'] as List? ?? []),
      travelKgCo2e: (map['travelKgCo2e'] as num).toDouble(),
      homeKgCo2e: (map['homeKgCo2e'] as num).toDouble(),
      foodKgCo2e: (map['foodKgCo2e'] as num).toDouble(),
      totalKgCo2e: (map['totalKgCo2e'] as num).toDouble(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Convenience method to create a copy with updated selections —
  /// used by the provider when the user toggles a checkbox.
  CarbonLog copyWith({
    List<String>? travel,
    List<String>? home,
    List<String>? food,
    double? travelKgCo2e,
    double? homeKgCo2e,
    double? foodKgCo2e,
    double? totalKgCo2e,
  }) {
    return CarbonLog(
      date: date,
      travel: travel ?? this.travel,
      home: home ?? this.home,
      food: food ?? this.food,
      travelKgCo2e: travelKgCo2e ?? this.travelKgCo2e,
      homeKgCo2e: homeKgCo2e ?? this.homeKgCo2e,
      foodKgCo2e: foodKgCo2e ?? this.foodKgCo2e,
      totalKgCo2e: totalKgCo2e ?? this.totalKgCo2e,
      updatedAt: DateTime.now(),
    );
  }
}