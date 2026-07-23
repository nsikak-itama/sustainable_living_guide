import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/travel_tip_service.dart';

final travelTipServiceProvider = Provider<TravelTipService>((ref) {
  return TravelTipService();
});