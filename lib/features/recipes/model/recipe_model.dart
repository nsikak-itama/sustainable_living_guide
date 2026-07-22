class Recipe {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String mealType; // "Lunch", "Dinner", "Dessert", etc.
  final int prepTimeMinutes;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> tags; // e.g. ["Plant-Based", "Seasonal"]
  final double co2eKg;
  final String impactBadge; // "Low Impact", "Zero Waste", "Seasonal"
  final String highlightTag; // e.g. "Eco-Certified", "High Protein"
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.mealType,
    required this.prepTimeMinutes,
    required this.ingredients,
    required this.instructions,
    required this.tags,
    required this.co2eKg,
    required this.impactBadge,
    required this.highlightTag,
    required this.createdAt,
  });

  factory Recipe.fromMap(String id, Map<String, dynamic> map) {
    return Recipe(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      mealType: map['mealType'] as String,
      prepTimeMinutes: (map['prepTimeMinutes'] as num).toInt(),
      ingredients: List<String>.from(map['ingredients'] as List? ?? []),
      instructions: List<String>.from(map['instructions'] as List? ?? []),
      tags: List<String>.from(map['tags'] as List? ?? []),
      co2eKg: (map['co2eKg'] as num).toDouble(),
      impactBadge: map['impactBadge'] as String? ?? '',
      highlightTag: map['highlightTag'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}