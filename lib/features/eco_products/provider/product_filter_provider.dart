import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/product_model.dart';
import 'product_list_provider.dart';

enum ProductSortOption { nameAZ, priceLowHigh }

/// Holds the current search text, selected category (nullable —
/// null means "show all categories"), and sort option.
class ProductFilterState {
  final String searchQuery;
  final String? selectedCategory;
  final ProductSortOption sortOption;

  const ProductFilterState({
    this.searchQuery = '',
    this.selectedCategory,
    this.sortOption = ProductSortOption.nameAZ,
  });

  ProductFilterState copyWith({
    String? searchQuery,
    String? selectedCategory,
    bool clearCategory = false,
    ProductSortOption? sortOption,
  }) {
    return ProductFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class ProductFilterController extends Notifier<ProductFilterState> {
  @override
  ProductFilterState build() => const ProductFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Tapping the already-selected category deselects it (back to
  /// "show all"), matching the default-show-all behavior we agreed on.
  void selectCategory(String category) {
    if (state.selectedCategory == category) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
  }

  void setSortOption(ProductSortOption option) {
    state = state.copyWith(sortOption: option);
  }
}

final productFilterControllerProvider =
    NotifierProvider<ProductFilterController, ProductFilterState>(() {
  return ProductFilterController();
});

/// The final list the UI renders: takes the raw product list,
/// applies category filter, search filter, and sort — all in-memory.
final filteredProductListProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productListProvider);
  final filter = ref.watch(productFilterControllerProvider);

  return productsAsync.whenData((products) {
    var result = products.where((product) {
      final matchesCategory = filter.selectedCategory == null ||
          product.category == filter.selectedCategory;

      final matchesSearch = filter.searchQuery.isEmpty ||
          product.name.toLowerCase().contains(filter.searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    switch (filter.sortOption) {
      case ProductSortOption.nameAZ:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.priceLowHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
    }

    return result;
  });
});