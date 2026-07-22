import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';

/// Handles fetching product data from Firestore. Read-only —
/// products are added/edited manually via the Firebase Console,
/// so no create/update/delete methods exist here.
class ProductService {
  final FirebaseFirestore _firestore;

  ProductService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches every product in the catalog. Since the catalog is
  /// expected to be small (manually curated), we fetch everything
  /// once and let the UI layer filter/sort/search in-memory.
  Future<List<Product>> getAllProducts() async {
    final snapshot = await _firestore.collection('products').get();

    return snapshot.docs
        .map((doc) => Product.fromMap(doc.id, doc.data()))
        .toList();
  }
}