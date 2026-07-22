import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/challenge_model.dart';
import 'challenges_service_provider.dart';

/// Fetches the full challenge catalog once per session — same
/// pattern as productListProvider.
final challengeListProvider = FutureProvider<List<Challenge>>((ref) async {
  final service = ref.watch(challengesServiceProvider);
  return service.getAllChallenges();
});