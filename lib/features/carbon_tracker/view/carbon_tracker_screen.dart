import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../provider/carbon_log_provider.dart';
import '../provider/daily_tips_provider.dart';
import '../widgets/footprint_ring_chart.dart';
import '../widgets/daily_tip_card.dart';
import '../widgets/activity_checkbox_tile.dart';

class CarbonTrackerScreen extends ConsumerWidget {
  const CarbonTrackerScreen({super.key});

  static const backgroundColor = Color(0xFFF5F4EF);
  static const darkGreen = Color(0xFF0B2B13);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logAsync = ref.watch(carbonLogControllerProvider);
    final tips = ref.watch(dailyTipsProvider);

    // Show a snackbar on save success or failure.
    ref.listen(carbonLogControllerProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Daily log updated!')),
        );
      }
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: ${next.error}')),
        );
      }
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: logAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Something went wrong: $error')),
          data: (log) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today's Footprint card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEEE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Today's Footprint",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FootprintRingChart(
                        travelKgCo2e: log.travelKgCo2e,
                        homeKgCo2e: log.homeKgCo2e,
                        foodKgCo2e: log.foodKgCo2e,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _LegendItem(color: FootprintRingChart.travelColor, label: 'Travel'),
                          _LegendItem(color: FootprintRingChart.homeColor, label: 'Home'),
                          _LegendItem(color: FootprintRingChart.foodColor, label: 'Food'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Daily Tips
                const Text(
                  'Daily Tips',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...tips.map((tip) => DailyTipCardWidget(tip: tip)),
                const SizedBox(height: 20),

                // Log Activity header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Log Activity',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('MMMM d, yyyy').format(DateTime.now()),
                      style: const TextStyle(color: darkGreen, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Travel section
                const _SectionHeader(icon: Icons.directions_car_outlined, label: 'Transportation Modes used today'),
                const SizedBox(height: 10),
                ActivityCheckboxTile(
                  label: 'Public Transportation',
                  checked: log.travel.contains('public_transportation'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'travel', key: 'public_transportation'),
                ),
                ActivityCheckboxTile(
                  label: 'Carpooling',
                  checked: log.travel.contains('carpooling'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'travel', key: 'carpooling'),
                ),
                ActivityCheckboxTile(
                  label: 'Personal Electric Vehicle (EV)',
                  checked: log.travel.contains('personal_ev'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'travel', key: 'personal_ev'),
                ),
                ActivityCheckboxTile(
                  label: 'Personal Gas/Diesel Vehicle',
                  checked: log.travel.contains('personal_gas_vehicle'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'travel', key: 'personal_gas_vehicle'),
                ),
                ActivityCheckboxTile(
                  label: 'Biking / Walking',
                  checked: log.travel.contains('biking_walking'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'travel', key: 'biking_walking'),
                ),
                const SizedBox(height: 20),

                // Home section
                const _SectionHeader(icon: Icons.bolt_outlined, label: 'Household Energy Consumed today'),
                const SizedBox(height: 10),
                ActivityCheckboxTile(
                  label: 'Renewable Source (Solar/Wind)',
                  checked: log.home.contains('renewable_source'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'home', key: 'renewable_source'),
                ),
                ActivityCheckboxTile(
                  label: 'Standard Grid Power',
                  checked: log.home.contains('standard_grid_power'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'home', key: 'standard_grid_power'),
                ),
                ActivityCheckboxTile(
                  label: 'Active Climate Heating / Cooling Used',
                  checked: log.home.contains('active_climate_control'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'home', key: 'active_climate_control'),
                ),
                const SizedBox(height: 20),

                // Food section
                const _SectionHeader(icon: Icons.restaurant_outlined, label: 'Daily Dietary Categories'),
                const SizedBox(height: 10),
                ActivityCheckboxTile(
                  label: 'Plant-Based / Vegan',
                  checked: log.food.contains('plant_based_vegan'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'food', key: 'plant_based_vegan'),
                ),
                ActivityCheckboxTile(
                  label: 'Vegetarian',
                  checked: log.food.contains('vegetarian'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'food', key: 'vegetarian'),
                ),
                ActivityCheckboxTile(
                  label: 'Locally Sourced Ingredients',
                  checked: log.food.contains('locally_sourced'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'food', key: 'locally_sourced'),
                ),
                ActivityCheckboxTile(
                  label: 'Meat / Dairy Consumed',
                  checked: log.food.contains('meat_dairy_consumed'),
                  onTap: () => ref
                      .read(carbonLogControllerProvider.notifier)
                      .toggle(category: 'food', key: 'meat_dairy_consumed'),
                ),
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(carbonLogControllerProvider.notifier).save();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    icon: const Icon(Icons.save_outlined, color: Colors.white),
                    label: const Text(
                      'Update Daily Log',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}