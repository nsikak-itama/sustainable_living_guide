import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/waste_tracker_service.dart';

final wasteTrackerServiceProvider = Provider<WasteTrackerService>((ref) {
  return WasteTrackerService();
});