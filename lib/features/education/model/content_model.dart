class EducationalContent {
  final String id;
  final String title;
  final String description;
  final String category;
  final String contentType; // "article", "video", "infographic"
  final String imageUrl;
  final int? readTimeMinutes;
  final String? bodyText;
  final String? videoUrl;
  final String? videoDurationLabel;
  final DateTime createdAt;

  EducationalContent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.contentType,
    required this.imageUrl,
    this.readTimeMinutes,
    this.bodyText,
    this.videoUrl,
    this.videoDurationLabel,
    required this.createdAt,
  });

  factory EducationalContent.fromMap(String id, Map<String, dynamic> map) {
    return EducationalContent(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      contentType: map['contentType'] as String,
      imageUrl: map['imageUrl'] as String,
      readTimeMinutes: (map['readTimeMinutes'] as num?)?.toInt(),
      bodyText: map['bodyText'] as String?,
      videoUrl: map['videoUrl'] as String?,
      videoDurationLabel: map['videoDurationLabel'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}