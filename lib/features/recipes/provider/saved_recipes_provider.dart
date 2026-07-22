import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recipe_service_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

/// Fetches the current user's saved (bookmarked) recipe IDs.
final savedRecipesProvider = FutureProvider<Set<String>>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return {};

  final service = ref.watch(recipeServiceProvider);
  return service.getSavedRecipeIds(user.uid);
});