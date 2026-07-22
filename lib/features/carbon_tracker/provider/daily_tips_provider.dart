import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'carbon_log_provider.dart';

class DailyTip {
  final String title;
  final String description;
  final String iconKey; // used by the UI to pick the right icon

  const DailyTip({
    required this.title,
    required this.description,
    required this.iconKey,
  });
}

const _allTips = [
  DailyTip(
    title: 'Switch to LEDs',
    description: 'Reduce household energy usage by up to 80% per bulb.',
    iconKey: 'lightbulb',
  ),
  DailyTip(
    title: 'Meatless Monday',
    description: 'Skipping meat once a week saves the water of 9 showers.',
    iconKey: 'leaf',
  ),
  DailyTip(
    title: 'Short Distances',
    description: 'Walk or bike trips under 2 miles to cut fuel emissions.',
    iconKey: 'bike',
  ),
  DailyTip(
    title: 'Great job going car-free!',
    description: 'Keep it up — biking and walking produce zero emissions.',
    iconKey: 'leaf',
  ),
  DailyTip(
    title: 'Try public transit',
    description: 'Swapping one car trip a week for transit cuts your footprint fast.',
    iconKey: 'bus',
  ),
];

/// Derives up to 3 relevant tips based on today's logged activity.
/// Falls back to defaults if fewer than 3 conditions match, so the
/// section is never empty.
final dailyTipsProvider = Provider<List<DailyTip>>((ref) {
  final logAsync = ref.watch(carbonLogControllerProvider);
  final log = logAsync.value;

  if (log == null) {
    return _allTips.take(3).toList();
  }

  final matched = <DailyTip>[];

  if (!log.home.contains('renewable_source')) {
    matched.add(_allTips[0]); // Switch to LEDs
  }
  if (log.food.contains('meat_dairy_consumed')) {
    matched.add(_allTips[1]); // Meatless Monday
  }
  if (log.travel.contains('personal_gas_vehicle') ||
      log.travel.contains('personal_ev')) {
    matched.add(_allTips[2]); // Short Distances
  }
  if (log.travel.contains('biking_walking') &&
      !log.travel.contains('personal_gas_vehicle')) {
    matched.add(_allTips[3]); // Great job going car-free
  }
  if (log.travel.contains('personal_gas_vehicle')) {
    matched.add(_allTips[4]); // Try public transit
  }

  if (matched.length >= 3) {
    return matched.take(3).toList();
  }

  // Fallback: fill remaining slots with tips not already matched.
  final remaining = _allTips.where((t) => !matched.contains(t)).toList();
  matched.addAll(remaining.take(3 - matched.length));

  return matched.take(3).toList();
});