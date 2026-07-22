import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../model/challenge_model.dart';
import '../model/user_challenge_model.dart';

class ChallengesService {
  final FirebaseFirestore _firestore;

  ChallengesService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static String todayDateString() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  /// Fetches the full challenge catalog (Console-curated content).
  Future<List<Challenge>> getAllChallenges() async {
    final snapshot = await _firestore.collection('challenges').get();
    return snapshot.docs
        .map((doc) => Challenge.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Fetches all challenges the current user has joined, keyed by
  /// challengeId for easy lookup against the catalog.
  Future<Map<String, UserChallenge>> getUserChallenges(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('userChallenges')
        .get();

    final map = <String, UserChallenge>{};
    for (final doc in snapshot.docs) {
      final userChallenge = UserChallenge.fromMap(doc.data());
      map[userChallenge.challengeId] = userChallenge;
    }
    return map;
  }

  /// Joins a challenge — creates a new UserChallenge record starting
  /// at 0 days completed.
  Future<void> joinChallenge({
    required String uid,
    required String challengeId,
  }) async {
    final userChallenge = UserChallenge.newJoin(challengeId);

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('userChallenges')
        .doc(challengeId)
        .set(userChallenge.toMap());
  }

  /// Checks in for today on a given challenge. Increments
  /// daysCompleted by 1, records today's date to prevent double
  /// check-ins, and marks the challenge "completed" once the
  /// duration is reached.
  Future<void> checkIn({
    required String uid,
    required UserChallenge current,
    required int durationDays,
  }) async {
    final today = todayDateString();

    // Guard against double check-in on the same day.
    if (current.lastCheckInDate == today) return;

    final newDaysCompleted = current.daysCompleted + 1;
    final newStatus =
        newDaysCompleted >= durationDays ? 'completed' : 'in_progress';

    final updated = current.copyWith(
      daysCompleted: newDaysCompleted,
      lastCheckInDate: today,
      status: newStatus,
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('userChallenges')
        .doc(current.challengeId)
        .set(updated.toMap());
  }
}