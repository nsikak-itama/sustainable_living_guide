import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/recipe_model.dart';

class RecipeService {
  final FirebaseFirestore _firestore;

  RecipeService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches the full recipe catalog (Console-curated).
  Future<List<Recipe>> getAllRecipes() async {
    final snapshot = await _firestore.collection('recipes').get();
    return snapshot.docs
        .map((doc) => Recipe.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Fetches the set of recipe IDs the current user has saved.
  Future<Set<String>> getSavedRecipeIds(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('savedRecipes')
        .get();

    return snapshot.docs.map((doc) => doc.id).toSet();
  }

  /// Saves (bookmarks) a recipe for the current user.
  Future<void> saveRecipe({
    required String uid,
    required String recipeId,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('savedRecipes')
        .doc(recipeId)
        .set({
      'recipeId': recipeId,
      'savedAt': DateTime.now(),
    });
  }

  /// Removes a recipe from the current user's saved list.
  Future<void> unsaveRecipe({
    required String uid,
    required String recipeId,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('savedRecipes')
        .doc(recipeId)
        .delete();
  }
}