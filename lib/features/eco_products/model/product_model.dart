class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final double price;
  final double rating;
  final int ratingsCount;
  final String badge;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.rating,
    required this.ratingsCount,
    required this.badge,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'price': price,
      'rating': rating,
      'ratingsCount': ratingsCount,
      'badge': badge,
      'createdAt': createdAt,
    };
  }

  /// Builds a Product from a Firestore document snapshot's data map.
  /// [id] is passed in separately since the document ID isn't part
  /// of the stored data itself.
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      category: map['category'] as String,
      price: (map['price'] as num).toDouble(),
      rating: (map['rating'] as num).toDouble(),
      ratingsCount: (map['ratingsCount'] as num).toInt(),
      badge: map['badge'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}