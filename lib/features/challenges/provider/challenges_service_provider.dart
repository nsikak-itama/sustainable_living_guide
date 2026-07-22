import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/challenges_service.dart';

final challengesServiceProvider = Provider<ChallengesService>((ref) {
  return ChallengesService();
});