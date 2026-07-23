import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/content_model.dart';
import '../provider/saved_content_provider.dart';
import '../provider/content_save_actions_provider.dart';

const _kBrandGreen = Color(0xFF0B2B13);
const _kBackground = Color(0xFFF5F4EF);

class ArticleDetailScreen extends ConsumerWidget {
  final EducationalContent article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedContentAsync = ref.watch(savedContentProvider);
    final saveActionsState = ref.watch(contentSaveActionsControllerProvider);

    ref.listen(contentSaveActionsControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: ${next.error}')),
        );
      }
    });

    final isSaved =
        savedContentAsync.asData?.value.contains(article.id) ?? false;
    final isLoading = saveActionsState.loadingContentId == article.id;

    return Scaffold(
      backgroundColor: _kBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: _kBackground,
            pinned: true,
            expandedHeight: 260,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black87),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: _kBrandGreen,
                          ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () => ref
                          .read(contentSaveActionsControllerProvider.notifier)
                          .toggleSave(
                            contentId: article.id,
                            currentlySaved: isSaved,
                          ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported_outlined,
                      size: 48, color: Colors.grey),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kBrandGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      article.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (article.readTimeMinutes != null)
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          '${article.readTimeMinutes} min read',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.bodyText ?? article.description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}