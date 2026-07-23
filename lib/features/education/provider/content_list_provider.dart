import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/content_model.dart';
import 'content_service_provider.dart';

final contentListProvider = FutureProvider<List<EducationalContent>>((ref) async {
  final service = ref.watch(contentServiceProvider);
  return service.getAllContent();
});