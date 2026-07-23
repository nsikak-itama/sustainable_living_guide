import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'community_service_provider.dart';
import '../../auth/provider/auth_state_provider.dart';
import '../../auth/model/user_model.dart';

class PostCreateController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createPost({
    required String text,
    File? imageFile,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final service = ref.read(communityServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Fetch the user's real profile from Firestore, since
      // Firebase Auth's displayName was never set at signup —
      // the actual name lives in the users/{uid} document.
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final authorName = userDoc.exists
          ? UserModel.fromMap(userDoc.data()!).name
          : 'Anonymous';

      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await service.uploadPostImage(imageFile, user.uid);
      }

      await service.createPost(
        authorUid: user.uid,
        authorName: authorName,
        text: text,
        imageUrl: imageUrl,
      );
    });
  }
}

final postCreateControllerProvider =
    AsyncNotifierProvider<PostCreateController, void>(() {
  return PostCreateController();
});