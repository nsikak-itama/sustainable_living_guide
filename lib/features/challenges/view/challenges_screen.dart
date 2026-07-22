import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/challenge_list_provider.dart';
import '../provider/user_challenges_provider.dart';
import '../provider/challenge_actions_provider.dart';
import '../model/challenge_model.dart';
import '../model/user_challenge_model.dart';
import '../service/challenges_service.dart';
import '../widgets/progress_summary_card.dart';
import '../widgets/daily_action_tile.dart';
import '../widgets/challenge_card.dart';
import '../widgets/achievement_banner.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  static const backgroundColor = Color(0xFFF5F4EF);
  static const darkGreen = Color(0xFF0B2B13);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(challengeListProvider);
    final userChallengesAsync = ref.watch(userChallengesProvider);
    final actionState = ref.watch(challengeActionsControllerProvider);
    final actionsController = ref.read(challengeActionsControllerProvider.notifier);

    // Show an error snackbar if a join/check-in action fails.
    ref.listen(challengeActionsControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: ${next.error}')),
        );
      }
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: challengesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Something went wrong: $error')),
          data: (challenges) {
            return userChallengesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Something went wrong: $error')),
              data: (userChallenges) {
                final today = ChallengesService.todayDateString();

                // In-progress challenges (for Daily Actions section).
                final inProgress = challenges.where((c) {
                  final uc = userChallenges[c.id];
                  return uc != null && uc.status == 'in_progress';
                }).toList();

                // Completed challenges (for the achievement banner —
                // just show the most recently completed one, if any).
                final completed = challenges.where((c) {
                  final uc = userChallenges[c.id];
                  return uc != null && uc.status == 'completed';
                }).toList();

                // Progress summary numbers.
                final activeCount = inProgress.length;
                final totalCo2Saved = challenges.fold<double>(0, (sum, c) {
                  final uc = userChallenges[c.id];
                  if (uc == null) return sum;
                  final fraction = uc.daysCompleted / c.durationDays;
                  return sum + (fraction * c.estimatedCo2SavedKg);
                });

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Progress',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ProgressSummaryCard(
                        activeCount: activeCount,
                        totalCo2SavedKg: totalCo2Saved,
                      ),
                      const SizedBox(height: 28),

                      if (inProgress.isNotEmpty) ...[
                        const Text(
                          'Daily Actions',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...inProgress.map((challenge) {
                          final uc = userChallenges[challenge.id]!;
                          final checkedInToday = uc.lastCheckInDate == today;

                          return DailyActionTile(
                            title: challenge.title,
                            daysCompleted: uc.daysCompleted,
                            durationDays: challenge.durationDays,
                            checkedInToday: checkedInToday,
                            onCheckIn: () {
                              actionsController.checkIn(
                                current: uc,
                                durationDays: challenge.durationDays,
                              );
                            },
                          );
                        }),
                        const SizedBox(height: 28),
                      ],

                      const Text(
                        'Active Challenges',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...challenges.map((challenge) {
                        final uc = userChallenges[challenge.id];
                        final status = uc?.status ?? 'not_started';

                        return ChallengeCard(
                          title: challenge.title,
                          description: challenge.description,
                          imageUrl: challenge.imageUrl,
                          frequencyLabel: challenge.frequencyLabel,
                          status: status,
                          isLoading: actionState.loadingChallengeId == challenge.id,
                          onActionTap: () {
                            if (status == 'not_started') {
                              actionsController.joinChallenge(challenge.id);
                            } else if (status == 'in_progress') {
                              actionsController.checkIn(
                                current: uc!,
                                durationDays: challenge.durationDays,
                              );
                            }
                          },
                        );
                      }),

                      if (completed.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        AchievementBanner(challengeTitle: completed.last.title),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}