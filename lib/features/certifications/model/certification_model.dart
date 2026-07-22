class Certification {
  final String id;
  final String name;
  final String labelType; // one of: fair_trade, energy_star, organic_bio, cruelty_free
  final String category;  // specific subtitle, e.g. "Agricultural Standard"
  final String imageUrl;
  final String description;
  final List<String> tags;
  final DateTime createdAt;

  Certification({
    required this.id,
    required this.name,
    required this.labelType,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.tags,
    required this.createdAt,
  });

  factory Certification.fromMap(String id, Map<String, dynamic> map) {
    return Certification(
      id: id,
      name: map['name'] as String,
      labelType: map['labelType'] as String,
      category: map['category'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      tags: List<String>.from(map['tags'] as List? ?? []),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}