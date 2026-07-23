import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'content_service_provider.dart';
import '../../auth/provider/auth_state_provider.dart';

final savedContentProvider = FutureProvider<Set<String>>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return {};

  final service = ref.watch(contentServiceProvider);
  return service.getSavedContentIds(user.uid);
});