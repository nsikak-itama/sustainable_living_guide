import 'package:cloud_firestore/cloud_firestore.dart';

/// Tracks one user's participation in one challenge: when they
/// joined, how many days they've checked in, and whether they've
/// already checked in today (to prevent double check-ins).
class UserChallenge {
  final String challengeId;
  final DateTime joinedAt;
  final int daysCompleted;
  final String? lastCheckInDate; // "yyyy-MM-dd", null if never checked in
  final String status; // "in_progress" or "completed"

  UserChallenge({
    required this.challengeId,
    required this.joinedAt,
    required this.daysCompleted,
    required this.lastCheckInDate,
    required this.status,
  });

  factory UserChallenge.newJoin(String challengeId) {
    return UserChallenge(
      challengeId: challengeId,
      joinedAt: DateTime.now(),
      daysCompleted: 0,
      lastCheckInDate: null,
      status: 'in_progress',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'challengeId': challengeId,
      'joinedAt': joinedAt,
      'daysCompleted': daysCompleted,
      'lastCheckInDate': lastCheckInDate,
      'status': status,
    };
  }

  factory UserChallenge.fromMap(Map<String, dynamic> map) {
    return UserChallenge(
      challengeId: map['challengeId'] as String,
      joinedAt: (map['joinedAt'] as Timestamp).toDate(),
      daysCompleted: (map['daysCompleted'] as num).toInt(),
      lastCheckInDate: map['lastCheckInDate'] as String?,
      status: map['status'] as String,
    );
  }

  UserChallenge copyWith({
    int? daysCompleted,
    String? lastCheckInDate,
    String? status,
  }) {
    return UserChallenge(
      challengeId: challengeId,
      joinedAt: joinedAt,
      daysCompleted: daysCompleted ?? this.daysCompleted,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      status: status ?? this.status,
    );
  }
}