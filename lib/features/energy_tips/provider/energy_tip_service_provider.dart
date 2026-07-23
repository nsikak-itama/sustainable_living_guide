import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/energy_tip_service.dart';

final energyTipServiceProvider = Provider<EnergyTipService>((ref) {
  return EnergyTipService();
});