import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/certification_service.dart';

final certificationServiceProvider = Provider<CertificationService>((ref) {
  return CertificationService();
});