import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/post_model.dart';
import '../provider/comment_provider.dart';
import '../provider/post_like_provider.dart';
import '../../auth/provider/auth_state_provider.dart';
import '../widgets/comment_tile.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();

  static const backgroundColor = Color(0xFFF5F4EF);
  static const darkGreen = Color(0xFF0B2B13);

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    ref.read(commentCreateControllerProvider.notifier).addComment(
          postId: widget.post.id,
          text: _commentController.text.trim(),
        );
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final commentsAsync = ref.watch(commentsStreamProvider(post.id));
    final hasLikedAsync = ref.watch(hasLikedProvider(post.id));
    final likeActionState = ref.watch(postLikeActionsControllerProvider);
    final likeController = ref.read(postLikeActionsControllerProvider.notifier);
    final commentCreateState = ref.watch(commentCreateControllerProvider);

    final isLiked = hasLikedAsync.value ?? false;
    final isLikeLoading = likeActionState.loadingPostId == post.id;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkGreen),
        title: const Text('Post', style: TextStyle(color: darkGreen)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
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
                        const SizedBox(width: 12),
                        Text(
                          post.authorName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(post.text, style: const TextStyle(fontSize: 15, height: 1.5)),
                    if (post.imageUrl != null) ...[
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          post.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: const Color(0xFFEDEDED),
                            child: const Icon(Icons.image_not_supported_outlined,
                                color: Colors.grey, size: 32),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
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
                            color: isLiked ? Colors.redAccent : Colors.black54,
                          ),
                          const SizedBox(width: 6),
                          Text('${post.likesCount} likes'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text(
                      'Comments',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    commentsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Text('Something went wrong: $error'),
                      data: (comments) {
                        if (comments.isEmpty) {
                          return const Text(
                            'No comments yet. Be the first to reply!',
                            style: TextStyle(color: Colors.black54),
                          );
                        }
                        return Column(
                          children: comments
                              .map((comment) => CommentTile(comment: comment))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 8,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  commentCreateState.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          onPressed: _submitComment,
                          icon: const Icon(Icons.send, color: darkGreen),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}