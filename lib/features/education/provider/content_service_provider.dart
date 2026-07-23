import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/content_service.dart';

final contentServiceProvider = Provider<ContentService>((ref) {
  return ContentService();
});