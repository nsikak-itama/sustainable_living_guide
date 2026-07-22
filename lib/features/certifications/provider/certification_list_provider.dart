import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/certification_model.dart';
import 'certification_service_provider.dart';

/// Fetches the full certification guide once per session.
final certificationListProvider = FutureProvider<List<Certification>>((ref) async {
  final service = ref.watch(certificationServiceProvider);
  return service.getAllCertifications();
});