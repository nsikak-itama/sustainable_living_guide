class Challenge {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String frequencyLabel; // e.g. "Weekly Sprint", "Recurring"
  final int durationDays;
  final double estimatedCo2SavedKg;
  final DateTime createdAt;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.frequencyLabel,
    required this.durationDays,
    required this.estimatedCo2SavedKg,
    required this.createdAt,
  });

  factory Challenge.fromMap(String id, Map<String, dynamic> map) {
    return Challenge(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      frequencyLabel: map['frequencyLabel'] as String? ?? '',
      durationDays: (map['durationDays'] as num).toInt(),
      estimatedCo2SavedKg: (map['estimatedCo2SavedKg'] as num).toDouble(),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}