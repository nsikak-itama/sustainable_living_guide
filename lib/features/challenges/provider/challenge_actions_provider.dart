import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'challenges_service_provider.dart';
import 'user_challenges_provider.dart';
import '../../auth/provider/auth_state_provider.dart';
import '../model/user_challenge_model.dart';

/// Tracks which single challenge (if any) currently has a join/
/// check-in action in flight, plus any error that occurred.
/// Using the challengeId (not a blanket bool) lets the UI show a
/// loading state on only the specific card being acted on.
class ChallengeActionState {
  final String? loadingChallengeId;
  final Object? error;

  const ChallengeActionState({this.loadingChallengeId, this.error});
}

class ChallengeActionsController extends Notifier<ChallengeActionState> {
  @override
  ChallengeActionState build() => const ChallengeActionState();

  Future<void> joinChallenge(String challengeId) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final service = ref.read(challengesServiceProvider);

    state = ChallengeActionState(loadingChallengeId: challengeId);
    try {
      await service.joinChallenge(uid: user.uid, challengeId: challengeId);
      ref.invalidate(userChallengesProvider);
      state = const ChallengeActionState();
    } catch (e) {
      state = ChallengeActionState(error: e);
    }
  }

  Future<void> checkIn({
    required UserChallenge current,
    required int durationDays,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final service = ref.read(challengesServiceProvider);

    state = ChallengeActionState(loadingChallengeId: current.challengeId);
    try {
      await service.checkIn(
        uid: user.uid,
        current: current,
        durationDays: durationDays,
      );
      ref.invalidate(userChallengesProvider);
      state = const ChallengeActionState();
    } catch (e) {
      state = ChallengeActionState(error: e);
    }
  }
}

final challengeActionsControllerProvider =
    NotifierProvider<ChallengeActionsController, ChallengeActionState>(() {
  return ChallengeActionsController();
});