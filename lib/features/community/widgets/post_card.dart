import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../model/post_model.dart';
import '../provider/post_like_provider.dart';
import '../provider/post_delete_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

/// A single post card in the feed — author, timestamp, text,
/// optional image, and like/comment actions. Shows a delete option
/// only if the current user is the author.
class PostCard extends ConsumerWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  static const darkGreen = Color(0xFF0B2B13);

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateProvider).value;
    final isOwnPost = currentUser?.uid == post.authorUid;

    final hasLikedAsync = ref.watch(hasLikedProvider(post.id));
    final likeActionState = ref.watch(postLikeActionsControllerProvider);
    final likeController = ref.read(postLikeActionsControllerProvider.notifier);

    final deleteState = ref.watch(postDeleteControllerProvider);
    final deleteController = ref.read(postDeleteControllerProvider.notifier);

    final isLiked = hasLikedAsync.value ?? false;
    final isLikeLoading = likeActionState.loadingPostId == post.id;
    final isDeleting = deleteState.deletingPostId == post.id;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFC9E4CB),
                  child: Text(
                    post.authorName.isNotEmpty
                        ? post.authorName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        _timeAgo(post.createdAt),
                        style: const TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                if (isOwnPost)
                  isDeleting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : PopupMenuButton<String>(
                          icon: const Icon(Icons.more_horiz, color: Colors.black45),
                          onSelected: (value) {
                            if (value == 'delete') {
                              deleteController.deletePost(post.id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete Post'),
                            ),
                          ],
                        ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.text, style: const TextStyle(fontSize: 14, height: 1.4)),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1.4,
                  child: Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFEDEDED),
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: Colors.grey, size: 32),
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
              ),
            ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: isLikeLoading
                      ? null
                      : () => likeController.toggleLike(
                            postId: post.id,
                            currentlyLiked: isLiked,
                          ),
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isLiked ? Colors.redAccent : Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text('${post.likesCount}',
                          style: const TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    const Icon(Icons.mode_comment_outlined, size: 18, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text('${post.commentsCount}',
                        style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}