class TravelTip {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;

  TravelTip({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
  });

  factory TravelTip.fromMap(String id, Map<String, dynamic> map) {
    return TravelTip(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}