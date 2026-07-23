import 'package:flutter/material.dart';
import '../model/content_model.dart';

class InfographicThumbnail extends StatelessWidget {
  final EducationalContent infographic;
  final VoidCallback onTap;

  const InfographicThumbnail({super.key, required this.infographic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            infographic.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFEDEDED),
              child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 32),
            ),
          ),
        ),
      ),
    );
  }
}