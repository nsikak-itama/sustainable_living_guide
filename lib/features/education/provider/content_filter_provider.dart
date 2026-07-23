import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/content_model.dart';
import 'content_list_provider.dart';

const contentCategories = ['climate', 'waste', 'fashion', 'food'];

/// Selected category; null means "All".
class ContentFilterController extends Notifier<String?> {
  @override
  String? build() => null;

  void selectCategory(String? category) {
    state = category;
  }
}

final contentFilterControllerProvider =
    NotifierProvider<ContentFilterController, String?>(() {
  return ContentFilterController();
});

/// Base filtered list (category-matched, all content types together).
final _categoryFilteredContentProvider =
    Provider<AsyncValue<List<EducationalContent>>>((ref) {
  final contentAsync = ref.watch(contentListProvider);
  final selectedCategory = ref.watch(contentFilterControllerProvider);

  return contentAsync.whenData((items) {
    if (selectedCategory == null) return items;
    return items.where((item) => item.category == selectedCategory).toList();
  });
});

/// Split by content type, each still respecting the category filter.
final filteredArticlesProvider = Provider<AsyncValue<List<EducationalContent>>>((ref) {
  final filtered = ref.watch(_categoryFilteredContentProvider);
  return filtered.whenData(
      (items) => items.where((i) => i.contentType == 'article').toList());
});

final filteredVideosProvider = Provider<AsyncValue<List<EducationalContent>>>((ref) {
  final filtered = ref.watch(_categoryFilteredContentProvider);
  return filtered.whenData(
      (items) => items.where((i) => i.contentType == 'video').toList());
});

final filteredInfographicsProvider = Provider<AsyncValue<List<EducationalContent>>>((ref) {
  final filtered = ref.watch(_categoryFilteredContentProvider);
  return filtered.whenData(
      (items) => items.where((i) => i.contentType == 'infographic').toList());
});