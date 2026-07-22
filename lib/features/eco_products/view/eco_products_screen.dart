import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/product_filter_provider.dart';
import '../widgets/category_filter_tile.dart';
import '../widgets/product_card.dart';

class EcoProductsScreen extends ConsumerWidget {
  const EcoProductsScreen({super.key});

  static const backgroundColor = Color(0xFFF5F4EF);
  static const darkGreen = Color(0xFF0B2B13);

  static const categories = [
    {
      'key': 'reusable_containers',
      'icon': Icons.local_drink_outlined,
      'title': 'Reusable Containers & Bottles',
      'subtitle': 'Durable glass and steel essentials',
    },
    {
      'key': 'zero_waste',
      'icon': Icons.recycling_outlined,
      'title': 'Zero-Waste & Plastic-Free Alternatives',
      'subtitle': 'Compostable and biodegradable swaps',
    },
    {
      'key': 'organic_food',
      'icon': Icons.eco_outlined,
      'title': 'Organic Food & Produce Options',
      'subtitle': 'Locally sourced and certified organic',
    },
    {
      'key': 'energy_efficient',
      'icon': Icons.energy_savings_leaf_outlined,
      'title': 'Energy Star / Energy-Efficient Appliances',
      'subtitle': 'Certified power-saving technology',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductListProvider);
    final filterState = ref.watch(productFilterControllerProvider);
    final filterController = ref.read(productFilterControllerProvider.notifier);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'EcoStep',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 16),

              // Search bar
              TextField(
                onChanged: filterController.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search eco-products...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFEDEDED),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Target Categories
              const Text(
                'Target Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...categories.map((cat) {
                final key = cat['key'] as String;
                return CategoryFilterTile(
                  icon: cat['icon'] as IconData,
                  title: cat['title'] as String,
                  subtitle: cat['subtitle'] as String,
                  selected: filterState.selectedCategory == key,
                  onTap: () => filterController.selectCategory(key),
                );
              }),
              const SizedBox(height: 24),

              // Product Feed header + sort dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<ProductSortOption>(
                    value: filterState.sortOption,
                    underline: const SizedBox.shrink(),
                    icon: const Icon(Icons.keyboard_arrow_down, color: darkGreen),
                    items: const [
                      DropdownMenuItem(
                        value: ProductSortOption.nameAZ,
                        child: Text('Name (A-Z)'),
                      ),
                      DropdownMenuItem(
                        value: ProductSortOption.priceLowHigh,
                        child: Text('Price: Low to High'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) filterController.setSortOption(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Product list
              filteredProducts.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('Something went wrong: $error')),
                ),
                data: (products) {
                  if (products.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No products found.')),
                    );
                  }
                  return Column(
                    children: products
                        .map((product) => ProductCard(product: product))
                        .toList(),
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