import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/product_service.dart';

/// Exposes a single shared instance of ProductService.
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});