import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/content_filter_provider.dart';
import '../provider/saved_content_provider.dart';
import '../provider/content_save_actions_provider.dart';
import '../widgets/category_filter_chip.dart';
import '../widgets/article_card.dart';
import '../widgets/video_card.dart';
import '../widgets/infographic_thumbnail.dart';
import 'article_detail_screen.dart';
import 'infographic_view_screen.dart';

const _kBrandGreen = Color(0xFF0B2B13);
const _kBackground = Color(0xFFF5F4EF);

class EducationScreen extends ConsumerWidget {
  const EducationScreen({super.key});

  // null = "All". contentCategories comes from content_filter_provider.dart.
  static const _chipLabels = ['All', 'Climate', 'Waste', 'Fashion', 'Food'];

  String? _categoryKeyFor(String label) {
    if (label == 'All') return null;
    return label.toLowerCase();
  }

  Future<void> _openVideoLink(BuildContext context, String? videoUrl) async {
    if (videoUrl == null) return;
    final uri = Uri.tryParse(videoUrl);
    if (uri == null) return;

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open this video link.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open this video link.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(contentFilterControllerProvider);
    final articlesAsync = ref.watch(filteredArticlesProvider);
    final videosAsync = ref.watch(filteredVideosProvider);
    final infographicsAsync = ref.watch(filteredInfographicsProvider);
    final savedContentAsync = ref.watch(savedContentProvider);
    final saveActionsState = ref.watch(contentSaveActionsControllerProvider);

    ref.listen(contentSaveActionsControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: ${next.error}')),
        );
      }
    });

    final savedIds = savedContentAsync.asData?.value ?? <String>{};

    return Scaffold(
      backgroundColor: _kBackground,
  
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // --- Category filter chips ---
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _chipLabels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final label = _chipLabels[index];
                final key = _categoryKeyFor(label);
                return CategoryFilterChip(
                  label: label,
                  selected: selectedCategory == key,
                  onTap: () => ref
                      .read(contentFilterControllerProvider.notifier)
                      .selectCategory(key),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // --- Featured Articles ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Featured Articles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          articlesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Could not load articles: $err'),
            ),
            data: (articles) {
              if (articles.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('No articles in this category yet.'),
                );
              }
              return Column(
                children: articles.map((article) {
                  final isSaved = savedIds.contains(article.id);
                  final isLoading =
                      saveActionsState.loadingContentId == article.id;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: ArticleCard(
                      article: article,
                      isSaved: isSaved,
                      isSaveLoading: isLoading,
                      onToggleSave: () => ref
                          .read(contentSaveActionsControllerProvider.notifier)
                          .toggleSave(
                            contentId: article.id,
                            currentlySaved: isSaved,
                          ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleDetailScreen(article: article),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 12),

          // --- How-to Videos ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'How-to Videos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          videosAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Could not load videos: $err'),
            ),
            data: (videos) {
              if (videos.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('No videos in this category yet.'),
                );
              }
              return SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: videos.map((video) {
                    return VideoCard(
                      video: video,
                      onTap: () => _openVideoLink(context, video.videoUrl),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // --- Impact Infographics ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Impact Infographics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          infographicsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Could not load infographics: $err'),
            ),
            data: (infographics) {
              if (infographics.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('No infographics in this category yet.'),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: infographics.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final infographic = infographics[index];
                    return InfographicThumbnail(
                      infographic: infographic,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InfographicViewScreen(infographic: infographic),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}