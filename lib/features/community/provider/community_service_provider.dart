import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/community_service.dart';

final communityServiceProvider = Provider<CommunityService>((ref) {
  return CommunityService();
});