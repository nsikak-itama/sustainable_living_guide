import 'package:flutter_riverpod/flutter_riverpod.dart';

const _wasteTips = [
  'Used coffee grounds are great for your garden! Mix them into the soil for a nitrogen boost.',
  'Rinse containers before recycling — greasy or food-soiled items can contaminate a whole batch.',
  'Buy in bulk to cut down on packaging waste from smaller, individually wrapped items.',
  'Compost fruit and vegetable scraps instead of tossing them — it reduces landfill methane.',
  'Swap single-use plastic bags for reusable totes on your next grocery run.',
  'Repair before you replace — many household items can be fixed instead of thrown away.',
  'Glass and metal can be recycled indefinitely without losing quality — always recycle them.',
];

/// Returns a deterministic "tip of the day" that rotates daily
/// based on the day of the year — same tip all day, changes daily,
/// no randomness on rebuild.
final wasteTipProvider = Provider<String>((ref) {
  final now = DateTime.now();
  final dayOfYear = int.parse(
    now.difference(DateTime(now.year, 1, 1)).inDays.toString(),
  );
  return _wasteTips[dayOfYear % _wasteTips.length];
});