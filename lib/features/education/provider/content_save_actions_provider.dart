import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'content_service_provider.dart';
import 'saved_content_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

class ContentSaveActionState {
  final String? loadingContentId;
  final Object? error;

  const ContentSaveActionState({this.loadingContentId, this.error});
}

class ContentSaveActionsController extends Notifier<ContentSaveActionState> {
  @override
  ContentSaveActionState build() => const ContentSaveActionState();

  Future<void> toggleSave({
    required String contentId,
    required bool currentlySaved,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final service = ref.read(contentServiceProvider);

    state = ContentSaveActionState(loadingContentId: contentId);
    try {
      if (currentlySaved) {
        await service.unsaveContent(uid: user.uid, contentId: contentId);
      } else {
        await service.saveContent(uid: user.uid, contentId: contentId);
      }
      ref.invalidate(savedContentProvider);
      state = const ContentSaveActionState();
    } catch (e) {
      state = ContentSaveActionState(error: e);
    }
  }
}

final contentSaveActionsControllerProvider =
    NotifierProvider<ContentSaveActionsController, ContentSaveActionState>(() {
  return ContentSaveActionsController();
});