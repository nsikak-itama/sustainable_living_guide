import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/recipe_service.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService();
});