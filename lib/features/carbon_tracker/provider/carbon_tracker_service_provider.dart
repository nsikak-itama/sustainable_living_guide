import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/carbon_tracker_service.dart';

/// Exposes a single shared instance of CarbonTrackerService.
final carbonTrackerServiceProvider = Provider<CarbonTrackerService>((ref) {
  return CarbonTrackerService();
});