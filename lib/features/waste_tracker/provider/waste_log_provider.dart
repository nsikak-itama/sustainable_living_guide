import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../model/waste_log_model.dart';
import 'waste_tracker_service_provider.dart';
import 'weekly_waste_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

String todayWasteDateString() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

class WasteLogController extends AsyncNotifier<WasteLog> {
  @override
  Future<WasteLog> build() async {
    final user = ref.watch(authStateProvider).value;
    final today = todayWasteDateString();

    if (user == null) {
      return WasteLog.empty(today);
    }

    final service = ref.read(wasteTrackerServiceProvider);
    final existing = await service.getLog(uid: user.uid, date: today);

    return existing ?? WasteLog.empty(today);
  }

  /// Updates a single kg field in-memory only. Persisted separately
  /// when the user taps "Log Data".
  void updateKg({
    double? landfillKg,
    double? recyclingKg,
    double? organicKg,
  }) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      landfillKg: landfillKg,
      recyclingKg: recyclingKg,
      organicKg: organicKg,
    ));
  }

  /// Toggles a habit key and immediately persists the change to
  /// Firestore, then refreshes the weekly data so the compliance
  /// count and chart reflect today's update right away.
  Future<void> toggleHabit(String key) async {
    final current = state.value;
    if (current == null) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final habits = List<String>.from(current.habits);
    if (habits.contains(key)) {
      habits.remove(key);
    } else {
      habits.add(key);
    }

    final updated = current.copyWith(habits: habits);
    state = AsyncData(updated);

    final service = ref.read(wasteTrackerServiceProvider);
    await service.saveLog(uid: user.uid, log: updated);

    // Refresh weekly data so compliance % and chart reflect the
    // just-saved habit change immediately.
    ref.invalidate(weeklyWasteProvider);
  }

  /// Saves the current kg values (and any habits, since they share
  /// the same document) to Firestore.
  Future<void> save() async {
    final current = state.value;
    if (current == null) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final service = ref.read(wasteTrackerServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await service.saveLog(uid: user.uid, log: current);
      return current;
    });

    ref.invalidate(weeklyWasteProvider);
  }
}

final wasteLogControllerProvider =
    AsyncNotifierProvider<WasteLogController, WasteLog>(() {
  return WasteLogController();
});