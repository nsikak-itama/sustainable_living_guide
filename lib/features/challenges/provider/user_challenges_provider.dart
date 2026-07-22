import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_challenge_model.dart';
import 'challenges_service_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

/// Fetches the current user's progress across all joined
/// challenges, keyed by challengeId. This is refreshed (re-fetched)
/// after join/check-in actions via ref.invalidateSelf, so the UI
/// always reflects the latest state after a write.
final userChallengesProvider =
    FutureProvider<Map<String, UserChallenge>>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return {};

  final service = ref.watch(challengesServiceProvider);
  return service.getUserChallenges(user.uid);
});