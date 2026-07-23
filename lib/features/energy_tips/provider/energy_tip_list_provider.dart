import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/energy_tip_model.dart';
import 'energy_tip_service_provider.dart';

/// Fetches all energy tips once per session.
final energyTipListProvider = FutureProvider<List<EnergyTip>>((ref) async {
  final service = ref.watch(energyTipServiceProvider);
  return service.getAllTips();
});