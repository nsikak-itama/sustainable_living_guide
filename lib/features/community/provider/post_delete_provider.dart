import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'community_service_provider.dart';

/// Tracks which single post (if any) currently has a delete action
/// in flight, plus any error.
class PostDeleteState {
  final String? deletingPostId;
  final Object? error;

  const PostDeleteState({this.deletingPostId, this.error});
}

class PostDeleteController extends Notifier<PostDeleteState> {
  @override
  PostDeleteState build() => const PostDeleteState();

  Future<void> deletePost(String postId) async {
    final service = ref.read(communityServiceProvider);

    state = PostDeleteState(deletingPostId: postId);
    try {
      await service.deletePost(postId);
      state = const PostDeleteState();
    } catch (e) {
      state = PostDeleteState(error: e);
    }
  }
}

final postDeleteControllerProvider =
    NotifierProvider<PostDeleteController, PostDeleteState>(() {
  return PostDeleteController();
});