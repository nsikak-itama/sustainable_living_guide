import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/waste_log_provider.dart';
import '../provider/weekly_waste_provider.dart';
import '../provider/waste_tip_provider.dart';
import '../widgets/weekly_waste_chart.dart';
import '../widgets/waste_input_field.dart';
import '../widgets/habit_checkbox_tile.dart';
import '../widgets/eco_tip_banner.dart';

class WasteTrackerScreen extends ConsumerStatefulWidget {
  const WasteTrackerScreen({super.key});

  @override
  ConsumerState<WasteTrackerScreen> createState() => _WasteTrackerScreenState();
}

class _WasteTrackerScreenState extends ConsumerState<WasteTrackerScreen> {
  late TextEditingController _landfillController;
  late TextEditingController _recyclingController;
  late TextEditingController _organicController;

  static const backgroundColor = Color(0xFFF5F4EF);
  static const darkGreen = Color(0xFF0B2B13);

  @override
  void initState() {
    super.initState();
    _landfillController = TextEditingController();
    _recyclingController = TextEditingController();
    _organicController = TextEditingController();
  }

  @override
  void dispose() {
    _landfillController.dispose();
    _recyclingController.dispose();
    _organicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logAsync = ref.watch(wasteLogControllerProvider);
    final weeklyAsync = ref.watch(weeklyWasteProvider);
    final complianceAsync = ref.watch(complianceProvider);
    final tip = ref.watch(wasteTipProvider);

    ref.listen(wasteLogControllerProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waste data logged!')),
        );
        // Refresh the weekly chart/compliance data so today's new
        // entry is reflected immediately.
        ref.invalidate(weeklyWasteProvider);
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
          data: (log) {
            // Keep text controllers in sync with loaded/saved values,
            // but only when they don't already reflect the current
            // in-memory value (avoids overwriting user's active typing).
            if (_landfillController.text != _formatKg(log.landfillKg)) {
              _landfillController.text = _formatKg(log.landfillKg);
            }
            if (_recyclingController.text != _formatKg(log.recyclingKg)) {
              _recyclingController.text = _formatKg(log.recyclingKg);
            }
            if (_organicController.text != _formatKg(log.organicKg)) {
              _organicController.text = _formatKg(log.organicKg);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Track Your Impact header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: darkGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Track Your Impact',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Every gram saved is a step toward a cleaner planet. '
                          "Today's goal: reduce landfill waste by 10%.",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Weekly Waste Trends chart
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weekly Waste Trends',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 16),
                        weeklyAsync.when(
                          loading: () => const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (error, _) => SizedBox(
                            height: 200,
                            child: Center(child: Text('Error: $error')),
                          ),
                          data: (logs) => WeeklyWasteChart(logs: logs),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Log New Waste
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEEE7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Log New Waste',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: WasteInputField(
                                label: 'Landfill (kg)',
                                controller: _landfillController,
                                onChanged: (value) {
                                  final parsed = double.tryParse(value) ?? 0;
                                  ref
                                      .read(wasteLogControllerProvider.notifier)
                                      .updateKg(landfillKg: parsed);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: WasteInputField(
                                label: 'Recycling (kg)',
                                controller: _recyclingController,
                                onChanged: (value) {
                                  final parsed = double.tryParse(value) ?? 0;
                                  ref
                                      .read(wasteLogControllerProvider.notifier)
                                      .updateKg(recyclingKg: parsed);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: WasteInputField(
                                label: 'Organic (kg)',
                                controller: _organicController,
                                onChanged: (value) {
                                  final parsed = double.tryParse(value) ?? 0;
                                  ref
                                      .read(wasteLogControllerProvider.notifier)
                                      .updateKg(organicKg: parsed);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ref
                                        .read(wasteLogControllerProvider.notifier)
                                        .save();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: darkGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                  label: const Text(
                                    'Log Data',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Daily Waste Habits Completed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daily Waste Habits Completed',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      complianceAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (fraction) {
                          final daysCompliant = (fraction * 7).round();
                          return Text(
                            '$daysCompliant/7 days',
                            style: const TextStyle(
                              color: darkGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  HabitCheckboxTile(
                    icon: Icons.recycling_outlined,
                    label: 'Sorted Recyclables (Plastic, Paper, Glass)',
                    checked: log.habits.contains('sorted_recyclables'),
                    onTap: () => ref
                        .read(wasteLogControllerProvider.notifier)
                        .toggleHabit('sorted_recyclables'),
                  ),
                  HabitCheckboxTile(
                    icon: Icons.compost_outlined,
                    label: 'Separated Organic Waste for Composting',
                    checked: log.habits.contains('separated_organic'),
                    onTap: () => ref
                        .read(wasteLogControllerProvider.notifier)
                        .toggleHabit('separated_organic'),
                  ),
                  HabitCheckboxTile(
                    icon: Icons.no_drinks_outlined,
                    label: 'Refused Single-Use Plastic Packaging',
                    checked: log.habits.contains('refused_plastic'),
                    onTap: () => ref
                        .read(wasteLogControllerProvider.notifier)
                        .toggleHabit('refused_plastic'),
                  ),
                  HabitCheckboxTile(
                    icon: Icons.brush_outlined,
                    label: 'Repurposed / Upcycled an Item',
                    checked: log.habits.contains('repurposed_item'),
                    onTap: () => ref
                        .read(wasteLogControllerProvider.notifier)
                        .toggleHabit('repurposed_item'),
                  ),
                  const SizedBox(height: 20),

                  EcoTipBanner(tip: tip),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatKg(double value) {
    // Avoids showing "0.0" as a forced overwrite while the user is
    // actively typing a different value.
    return value == 0 ? '' : value.toString();
  }
}