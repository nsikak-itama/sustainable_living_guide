import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'community_service_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

/// Fetches whether the current user has liked a specific post.
/// Uses .family so each post gets its own independent provider
/// instance, keyed by postId.
final hasLikedProvider = FutureProvider.family<bool, String>((ref, postId) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;

  final service = ref.watch(communityServiceProvider);
  return service.hasLiked(postId: postId, uid: user.uid);
});

/// Tracks which single post (if any) currently has a like/unlike
/// action in flight — same per-item loading pattern used elsewhere.
class PostLikeActionState {
  final String? loadingPostId;
  final Object? error;

  const PostLikeActionState({this.loadingPostId, this.error});
}

class PostLikeActionsController extends Notifier<PostLikeActionState> {
  @override
  PostLikeActionState build() => const PostLikeActionState();

  Future<void> toggleLike({
    required String postId,
    required bool currentlyLiked,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final service = ref.read(communityServiceProvider);

    state = PostLikeActionState(loadingPostId: postId);
    try {
      if (currentlyLiked) {
        await service.unlikePost(postId: postId, uid: user.uid);
      } else {
        await service.likePost(postId: postId, uid: user.uid);
      }
      // Refresh this specific post's "have I liked it" state.
      ref.invalidate(hasLikedProvider(postId));
      state = const PostLikeActionState();
    } catch (e) {
      state = PostLikeActionState(error: e);
    }
  }
}

final postLikeActionsControllerProvider =
    NotifierProvider<PostLikeActionsController, PostLikeActionState>(() {
  return PostLikeActionsController();
});