import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/travel_tip_model.dart';
import 'travel_tip_service_provider.dart';

final travelTipListProvider = FutureProvider<List<TravelTip>>((ref) async {
  final service = ref.watch(travelTipServiceProvider);
  return service.getAllTips();
});