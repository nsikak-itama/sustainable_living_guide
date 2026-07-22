import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../model/carbon_log_model.dart';
import 'carbon_tracker_service_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

/// Returns today's date as "yyyy-MM-dd", used as the Firestore doc ID.
String todayDateString() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

/// Manages the current day's CarbonLog: loading it from Firestore
/// on start, updating it live as checkboxes are toggled, and saving
/// it back to Firestore when the user taps "Update Daily Log".
class CarbonLogController extends AsyncNotifier<CarbonLog> {
  @override
  Future<CarbonLog> build() async {
    final user = ref.watch(authStateProvider).value;
    final today = todayDateString();

    if (user == null) {
      // Shouldn't normally happen since this screen is only reachable
      // when logged in, but guarding defensively.
      return CarbonLog.empty(today);
    }

    final service = ref.read(carbonTrackerServiceProvider);
    final existing = await service.getLog(uid: user.uid, date: today);

    return existing ?? CarbonLog.empty(today);
  }

  /// Toggles a single activity key within a category and recalculates
  /// totals immediately, so the UI (ring chart, kg values) updates
  /// live even before the user saves.
  void toggle({
    required String category, // 'travel', 'home', or 'food'
    required String key,
  }) {
    final current = state.value;
    if (current == null) return;

    final service = ref.read(carbonTrackerServiceProvider);

    List<String> travel = List.from(current.travel);
    List<String> home = List.from(current.home);
    List<String> food = List.from(current.food);

    List<String> target;
    switch (category) {
      case 'travel':
        target = travel;
        break;
      case 'home':
        target = home;
        break;
      case 'food':
        target = food;
        break;
      default:
        return;
    }

    if (target.contains(key)) {
      target.remove(key);
    } else {
      target.add(key);
    }

    final recalculated = service.buildLog(
      date: current.date,
      travel: travel,
      home: home,
      food: food,
    );

    state = AsyncData(recalculated);
  }

  /// Saves the current selections to Firestore.
  Future<void> save() async {
    final current = state.value;
    if (current == null) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final service = ref.read(carbonTrackerServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await service.saveLog(uid: user.uid, log: current);
      return current;
    });
  }
}

final carbonLogControllerProvider =
    AsyncNotifierProvider<CarbonLogController, CarbonLog>(() {
  return CarbonLogController();
});