import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/travel_tip_filter_provider.dart';
import '../widgets/travel_category_summary_card.dart';
import '../widgets/travel_tip_card.dart';

class TravelTipsScreen extends ConsumerWidget {
  const TravelTipsScreen({super.key});

  static const backgroundColor = Color(0xFFF5F4EF);
  static const darkGreen = Color(0xFF0B2B13);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTips = ref.watch(filteredTravelTipListProvider);
    final selectedCategory = ref.watch(travelTipFilterControllerProvider);
    final filterController = ref.read(travelTipFilterControllerProvider.notifier);
    final categoryCounts = ref.watch(travelTipCategoryCountsProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Eco-Travel Suggestions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => filterController.selectCategory(null),
                    child: const Text(
                      'View All',
                      style: TextStyle(color: darkGreen, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: travelTipCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final category = travelTipCategories[index];
                    final key = category['key']!;
                    return TravelCategorySummaryCard(
                      title: category['label']!,
                      tipCount: categoryCounts[key] ?? 0,
                      selected: selectedCategory == key,
                      onTap: () => filterController.selectCategory(key),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              Text(
                selectedCategory == null
                    ? 'All Tips'
                    : travelTipCategories
                        .firstWhere((c) => c['key'] == selectedCategory)['label']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              filteredTips.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('Something went wrong: $error')),
                ),
                data: (tips) {
                  if (tips.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No tips found.')),
                    );
                  }
                  return Column(
                    children: tips
                        .map((tip) => TravelTipCard(
                              title: tip.title,
                              description: tip.description,
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}