import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/carbon_log_model.dart';

/// Handles all direct Firestore communication for carbon footprint
/// logs, plus the emission-value calculation logic (Option A:
/// flat/average kg CO2e per checked activity, summed per category).
class CarbonTrackerService {
  final FirebaseFirestore _firestore;

  CarbonTrackerService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Emission factor lookup tables — MVP flat estimates (kg CO2e).
  static const Map<String, double> travelFactors = {
    'public_transportation': 2.0,
    'carpooling': 1.5,
    'personal_ev': 1.0,
    'personal_gas_vehicle': 4.6,
    'biking_walking': 0.0,
  };

  static const Map<String, double> homeFactors = {
    'renewable_source': 0.5,
    'standard_grid_power': 5.5,
    'active_climate_control': 3.0,
  };

  static const Map<String, double> foodFactors = {
    'plant_based_vegan': 1.5,
    'vegetarian': 2.5,
    'locally_sourced': 1.0,
    'meat_dairy_consumed': 6.0,
  };

  /// Sums the kg CO2e for a list of selected activity keys within
  /// a given category's factor table.
  double _calculateCategoryTotal(
    List<String> selectedKeys,
    Map<String, double> factors,
  ) {
    double total = 0;
    for (final key in selectedKeys) {
      total += factors[key] ?? 0;
    }
    return total;
  }

  /// Builds a fully-calculated CarbonLog from raw selections.
  /// Called whenever the user toggles a checkbox, so totals are
  /// always up to date before saving.
  CarbonLog buildLog({
    required String date,
    required List<String> travel,
    required List<String> home,
    required List<String> food,
  }) {
    final travelTotal = _calculateCategoryTotal(travel, travelFactors);
    final homeTotal = _calculateCategoryTotal(home, homeFactors);
    final foodTotal = _calculateCategoryTotal(food, foodFactors);

    return CarbonLog(
      date: date,
      travel: travel,
      home: home,
      food: food,
      travelKgCo2e: travelTotal,
      homeKgCo2e: homeTotal,
      foodKgCo2e: foodTotal,
      totalKgCo2e: travelTotal + homeTotal + foodTotal,
      updatedAt: DateTime.now(),
    );
  }

  /// Fetches the log for a given date, if one exists.
  Future<CarbonLog?> getLog({
    required String uid,
    required String date,
  }) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('carbonLogs')
        .doc(date)
        .get();

    if (!doc.exists) return null;
    return CarbonLog.fromMap(doc.data()!);
  }

  /// Creates or updates (upserts) the log for a given date.
  Future<void> saveLog({
    required String uid,
    required CarbonLog log,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('carbonLogs')
        .doc(log.date)
        .set(log.toMap());
  }
}