import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/waste_log_model.dart';
import 'waste_tracker_service_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

/// Fetches the last 7 days of waste logs — used for both the
/// weekly trends chart and the habit compliance percentage.
final weeklyWasteProvider = FutureProvider<List<WasteLog>>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return [];

  final service = ref.watch(wasteTrackerServiceProvider);
  return service.getLastSevenDays(user.uid);
});

/// Derives the compliance percentage: the fraction of the last 7
/// days where at least one habit was checked.
final complianceProvider = Provider<AsyncValue<double>>((ref) {
  final logsAsync = ref.watch(weeklyWasteProvider);

  return logsAsync.whenData((logs) {
    if (logs.isEmpty) return 0.0;
    final compliantDays = logs.where((log) => log.habits.isNotEmpty).length;
    return compliantDays / logs.length;
  });
});