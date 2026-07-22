import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/recipe_model.dart';
import 'recipe_list_provider.dart';
import 'saved_recipes_provider.dart';

enum RecipeFilter { all, plantBased, seasonal, saved }

/// Holds both the selected filter chip and the current search text.
class RecipeFilterState {
  final RecipeFilter selectedFilter;
  final String searchQuery;

  const RecipeFilterState({
    this.selectedFilter = RecipeFilter.all,
    this.searchQuery = '',
  });

  RecipeFilterState copyWith({
    RecipeFilter? selectedFilter,
    String? searchQuery,
  }) {
    return RecipeFilterState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class RecipeFilterController extends Notifier<RecipeFilterState> {
  @override
  RecipeFilterState build() => const RecipeFilterState();

  void selectFilter(RecipeFilter filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final recipeFilterControllerProvider =
    NotifierProvider<RecipeFilterController, RecipeFilterState>(() {
  return RecipeFilterController();
});

/// Derives the filtered recipe list based on both the selected
/// chip and the search query — both apply together.
final filteredRecipeListProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  final recipesAsync = ref.watch(recipeListProvider);
  final filterState = ref.watch(recipeFilterControllerProvider);
  final savedAsync = ref.watch(savedRecipesProvider);

  return recipesAsync.whenData((recipes) {
    var result = recipes;

    switch (filterState.selectedFilter) {
      case RecipeFilter.all:
        break; // no chip filtering
      case RecipeFilter.plantBased:
        result = result.where((r) => r.tags.contains('Plant-Based')).toList();
        break;
      case RecipeFilter.seasonal:
        result = result.where((r) => r.tags.contains('Seasonal')).toList();
        break;
      case RecipeFilter.saved:
        final savedIds = savedAsync.value ?? {};
        result = result.where((r) => savedIds.contains(r.id)).toList();
        break;
    }

    if (filterState.searchQuery.isNotEmpty) {
      result = result
          .where((r) =>
              r.name.toLowerCase().contains(filterState.searchQuery.toLowerCase()))
          .toList();
    }

    return result;
  });
});