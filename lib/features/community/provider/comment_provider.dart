import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/comment_model.dart';
import 'community_service_provider.dart';
import '../../auth/provider/auth_state_provider.dart';
import '../../auth/model/user_model.dart';

/// Live stream of comments for a specific post, keyed by postId
/// via .family.
final commentsStreamProvider =
    StreamProvider.family<List<Comment>, String>((ref, postId) {
  final service = ref.watch(communityServiceProvider);
  return service.streamComments(postId);
});

class CommentCreateController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addComment({
    required String postId,
    required String text,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final service = ref.read(communityServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final authorName = userDoc.exists
          ? UserModel.fromMap(userDoc.data()!).name
          : 'Anonymous';

      await service.addComment(
        postId: postId,
        authorUid: user.uid,
        authorName: authorName,
        text: text,
      );
    });
  }
}

final commentCreateControllerProvider =
    AsyncNotifierProvider<CommentCreateController, void>(() {
  return CommentCreateController();
});