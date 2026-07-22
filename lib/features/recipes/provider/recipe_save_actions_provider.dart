import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recipe_service_provider.dart';
import 'saved_recipes_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

/// Tracks which single recipe (if any) currently has a save/unsave
/// action in flight — same per-item loading pattern used to fix
/// the Challenges feature's shared-loading bug.
class RecipeSaveActionState {
  final String? loadingRecipeId;
  final Object? error;

  const RecipeSaveActionState({this.loadingRecipeId, this.error});
}

class RecipeSaveActionsController extends Notifier<RecipeSaveActionState> {
  @override
  RecipeSaveActionState build() => const RecipeSaveActionState();

  Future<void> toggleSave({
    required String recipeId,
    required bool currentlySaved,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final service = ref.read(recipeServiceProvider);

    state = RecipeSaveActionState(loadingRecipeId: recipeId);
    try {
      if (currentlySaved) {
        await service.unsaveRecipe(uid: user.uid, recipeId: recipeId);
      } else {
        await service.saveRecipe(uid: user.uid, recipeId: recipeId);
      }
      ref.invalidate(savedRecipesProvider);
      state = const RecipeSaveActionState();
    } catch (e) {
      state = RecipeSaveActionState(error: e);
    }
  }
}

final recipeSaveActionsControllerProvider =
    NotifierProvider<RecipeSaveActionsController, RecipeSaveActionState>(() {
  return RecipeSaveActionsController();
});