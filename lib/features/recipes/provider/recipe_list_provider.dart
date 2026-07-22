import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/recipe_model.dart';
import 'recipe_service_provider.dart';

/// Fetches the full recipe catalog once per session.
final recipeListProvider = FutureProvider<List<Recipe>>((ref) async {
  final service = ref.watch(recipeServiceProvider);
  return service.getAllRecipes();
});