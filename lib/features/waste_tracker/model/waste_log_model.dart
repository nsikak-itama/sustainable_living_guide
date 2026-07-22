import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single day's waste reduction log: numeric weights
/// logged for landfill/recycling/organic waste, plus which daily
/// habits the user checked off.
class WasteLog {
  final String date; // "yyyy-MM-dd", also the Firestore doc ID
  final double landfillKg;
  final double recyclingKg;
  final double organicKg;
  final List<String> habits;
  final DateTime updatedAt;

  WasteLog({
    required this.date,
    required this.landfillKg,
    required this.recyclingKg,
    required this.organicKg,
    required this.habits,
    required this.updatedAt,
  });

  factory WasteLog.empty(String date) {
    return WasteLog(
      date: date,
      landfillKg: 0,
      recyclingKg: 0,
      organicKg: 0,
      habits: [],
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'landfillKg': landfillKg,
      'recyclingKg': recyclingKg,
      'organicKg': organicKg,
      'habits': habits,
      'updatedAt': updatedAt,
    };
  }

  factory WasteLog.fromMap(Map<String, dynamic> map) {
    return WasteLog(
      date: map['date'] as String,
      landfillKg: (map['landfillKg'] as num).toDouble(),
      recyclingKg: (map['recyclingKg'] as num).toDouble(),
      organicKg: (map['organicKg'] as num).toDouble(),
      habits: List<String>.from(map['habits'] as List? ?? []),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  WasteLog copyWith({
    double? landfillKg,
    double? recyclingKg,
    double? organicKg,
    List<String>? habits,
  }) {
    return WasteLog(
      date: date,
      landfillKg: landfillKg ?? this.landfillKg,
      recyclingKg: recyclingKg ?? this.recyclingKg,
      organicKg: organicKg ?? this.organicKg,
      habits: habits ?? this.habits,
      updatedAt: DateTime.now(),
    );
  }
}