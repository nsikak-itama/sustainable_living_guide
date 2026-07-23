import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/travel_tip_model.dart';
import 'travel_tip_list_provider.dart';

const travelTipCategories = [
  {'key': 'public_transit', 'label': 'Public Transportation'},
  {'key': 'carpooling', 'label': 'Carpooling'},
  {'key': 'sustainable_hotels', 'label': 'Sustainable Hotels'},
  {'key': 'vacation_travel', 'label': 'Vacation & Trip Planning'},
];

class TravelTipFilterController extends Notifier<String?> {
  @override
  String? build() => null;

  void selectCategory(String? category) {
    state = category;
  }
}

final travelTipFilterControllerProvider =
    NotifierProvider<TravelTipFilterController, String?>(() {
  return TravelTipFilterController();
});

final filteredTravelTipListProvider = Provider<AsyncValue<List<TravelTip>>>((ref) {
  final tipsAsync = ref.watch(travelTipListProvider);
  final selectedCategory = ref.watch(travelTipFilterControllerProvider);

  return tipsAsync.whenData((tips) {
    if (selectedCategory == null) return tips;
    return tips.where((tip) => tip.category == selectedCategory).toList();
  });
});

final travelTipCategoryCountsProvider = Provider<Map<String, int>>((ref) {
  final tipsAsync = ref.watch(travelTipListProvider);
  final tips = tipsAsync.value ?? [];

  final counts = <String, int>{};
  for (final category in travelTipCategories) {
    final key = category['key']!;
    counts[key] = tips.where((tip) => tip.category == key).length;
  }
  return counts;
});