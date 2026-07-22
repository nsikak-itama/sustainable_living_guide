import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/recipe_filter_provider.dart';
import '../provider/saved_recipes_provider.dart';
import '../provider/recipe_save_actions_provider.dart';
import '../widgets/recipe_filter_chip.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  static const backgroundColor = Color(0xFFF5F4EF);
  static const darkGreen = Color(0xFF0B2B13);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredRecipes = ref.watch(filteredRecipeListProvider);
    final filterState = ref.watch(recipeFilterControllerProvider);
    final filterController = ref.read(recipeFilterControllerProvider.notifier);
    final savedAsync = ref.watch(savedRecipesProvider);
    final saveActionState = ref.watch(recipeSaveActionsControllerProvider);
    final saveActionsController = ref.read(recipeSaveActionsControllerProvider.notifier);

    ref.listen(recipeSaveActionsControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: ${next.error}')),
        );
      }
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header banner
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1490645935967-10de6ba17061',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sustainable Cooking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lower your carbon footprint, one plate at a time.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Search bar (UI only — filtering handled by chips, per SRS scope)
              TextField(
                onChanged: filterController.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search eco-friendly recipes...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFEDEDED),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter chips
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    RecipeFilterChipWidget(
                      label: 'All Recipes',
                      selected: filterState.selectedFilter == RecipeFilter.all,
                      onTap: () => filterController.selectFilter(RecipeFilter.all),
                    ),
                    const SizedBox(width: 10),
                    RecipeFilterChipWidget(
                      label: 'Plant-Based',
                      selected: filterState.selectedFilter == RecipeFilter.plantBased,
                      onTap: () => filterController.selectFilter(RecipeFilter.plantBased),
                    ),
                    const SizedBox(width: 10),
                    RecipeFilterChipWidget(
                      label: 'Seasonal',
                      selected: filterState.selectedFilter == RecipeFilter.seasonal,
                      onTap: () => filterController.selectFilter(RecipeFilter.seasonal),
                    ),
                    const SizedBox(width: 10),
                    RecipeFilterChipWidget(
                      label: 'Saved',
                      selected: filterState.selectedFilter == RecipeFilter.saved,
                      onTap: () => filterController.selectFilter(RecipeFilter.saved),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Recipe list
              filteredRecipes.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('Something went wrong: $error')),
                ),
                data: (recipes) {
                  if (recipes.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No recipes found.')),
                    );
                  }
                  final savedIds = savedAsync.value ?? {};

                  return Column(
                    children: recipes.map((recipe) {
                      final isSaved = savedIds.contains(recipe.id);
                      return RecipeCard(
                        recipe: recipe,
                        isSaved: isSaved,
                        isSaveLoading: saveActionState.loadingRecipeId == recipe.id,
                        onToggleSave: () => saveActionsController.toggleSave(
                          recipeId: recipe.id,
                          currentlySaved: isSaved,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}