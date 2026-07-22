import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../model/waste_log_model.dart';

class WasteTrackerService {
  final FirebaseFirestore _firestore;

  WasteTrackerService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static String dateString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Fetches a single day's log, if it exists.
  Future<WasteLog?> getLog({
    required String uid,
    required String date,
  }) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('wasteLogs')
        .doc(date)
        .get();

    if (!doc.exists) return null;
    return WasteLog.fromMap(doc.data()!);
  }

  /// Creates or updates (upserts) a day's log.
  Future<void> saveLog({
    required String uid,
    required WasteLog log,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('wasteLogs')
        .doc(log.date)
        .set(log.toMap());
  }

  /// Fetches the last 7 days of logs (today and the 6 days before),
  /// returned as a list ordered oldest-to-newest. Days with no log
  /// are represented as an empty WasteLog so the chart always has
  /// exactly 7 entries.
  Future<List<WasteLog>> getLastSevenDays(String uid) async {
    final today = DateTime.now();
    final dates = List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      return dateString(day);
    });

    final collection =
        _firestore.collection('users').doc(uid).collection('wasteLogs');

    // Fetch all 7 possible documents by ID. Firestore has no
    // built-in "fetch these specific IDs" batch-get in the same way
    // as a query, so we fetch them individually in parallel.
    final futures = dates.map((date) => collection.doc(date).get());
    final snapshots = await Future.wait(futures);

    return List.generate(7, (i) {
      final snapshot = snapshots[i];
      if (snapshot.exists) {
        return WasteLog.fromMap(snapshot.data()!);
      }
      return WasteLog.empty(dates[i]);
    });
  }
}