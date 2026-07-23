import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/post_model.dart';
import 'community_service_provider.dart';

/// Live stream of the post feed, newest first. Unlike our
/// Console-curated content (which fetches once), this uses a real
/// Firestore stream so new posts from other users appear
/// automatically without a manual refresh.
final postFeedProvider = StreamProvider<List<Post>>((ref) {
  final service = ref.watch(communityServiceProvider);
  return service.streamPosts();
});