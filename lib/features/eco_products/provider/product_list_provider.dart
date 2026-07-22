import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/product_model.dart';
import 'product_service_provider.dart';

/// Fetches the full product catalog once. This is the only
/// provider in this feature that actually talks to Firestore —
/// everything else (search, filter, sort) operates on this cached
/// list in-memory, so toggling a filter never triggers a new
/// network request.
final productListProvider = FutureProvider<List<Product>>((ref) async {
  final service = ref.watch(productServiceProvider);
  return service.getAllProducts();
});