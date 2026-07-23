import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/energy_tip_model.dart';
import 'energy_tip_list_provider.dart';

/// Fixed category set for the summary cards.
const energyTipCategories = [
  {'key': 'appliances', 'label': 'Appliances'},
  {'key': 'climate_control', 'label': 'Climate Control'},
  {'key': 'lighting', 'label': 'Lighting'},
  {'key': 'renewable_energy', 'label': 'Renewable Energy'},
];

/// Holds the selected category; null means "View All" (no filter).
class EnergyTipFilterController extends Notifier<String?> {
  @override
  String? build() => null;

  void selectCategory(String? category) {
    state = category;
  }
}

final energyTipFilterControllerProvider =
    NotifierProvider<EnergyTipFilterController, String?>(() {
  return EnergyTipFilterController();
});

/// The filtered list of tips based on the selected category.
final filteredEnergyTipListProvider = Provider<AsyncValue<List<EnergyTip>>>((ref) {
  final tipsAsync = ref.watch(energyTipListProvider);
  final selectedCategory = ref.watch(energyTipFilterControllerProvider);

  return tipsAsync.whenData((tips) {
    if (selectedCategory == null) return tips;
    return tips.where((tip) => tip.category == selectedCategory).toList();
  });
});

/// Computes a count of tips per category, used for the summary
/// card text (e.g., "12 actionable tips").
final energyTipCategoryCountsProvider = Provider<Map<String, int>>((ref) {
  final tipsAsync = ref.watch(energyTipListProvider);
  final tips = tipsAsync.value ?? [];

  final counts = <String, int>{};
  for (final category in energyTipCategories) {
    final key = category['key']!;
    counts[key] = tips.where((tip) => tip.category == key).length;
  }
  return counts;
});