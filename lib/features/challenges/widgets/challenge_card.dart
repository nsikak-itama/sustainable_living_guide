import 'package:flutter/material.dart';

/// The browsable challenge card — image, status badge, title,
/// description, frequency label, and a Join/Update/Completed button.
/// No participant avatars, per our scope decision.
class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String frequencyLabel;
  final String status; // "not_started", "in_progress", "completed"
  final bool isLoading;
  final VoidCallback? onActionTap;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.frequencyLabel,
    required this.status,
    required this.isLoading,
    required this.onActionTap,
  });

  static const darkGreen = Color(0xFF0B2B13);

  String get _statusLabel {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Not Started';
    }
  }

  Color get _statusColor {
    switch (status) {
      case 'in_progress':
        return darkGreen;
      case 'completed':
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  String get _buttonLabel {
    switch (status) {
      case 'in_progress':
        return 'Update';
      case 'completed':
        return 'Completed';
      default:
        return 'Join Challenge';
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonEnabled = status != 'completed' && !isLoading;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.6,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFEDEDED),
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: Colors.grey, size: 40),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFFEDEDED),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  frequencyLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: buttonEnabled ? onActionTap : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            status == 'completed' ? Colors.grey.shade300 : darkGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _buttonLabel,
                              style: TextStyle(
                                color: status == 'completed'
                                    ? Colors.black54
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}