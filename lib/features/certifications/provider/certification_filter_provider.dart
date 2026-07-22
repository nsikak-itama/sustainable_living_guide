import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/certification_model.dart';
import 'certification_list_provider.dart';

/// Holds the set of currently selected labelType filters
/// (multi-select). Empty set means "show all".
class CertificationFilterController extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String labelType) {
    final updated = Set<String>.from(state);
    if (updated.contains(labelType)) {
      updated.remove(labelType);
    } else {
      updated.add(labelType);
    }
    state = updated;
  }

  void clearAll() {
    state = {};
  }
}

final certificationFilterControllerProvider =
    NotifierProvider<CertificationFilterController, Set<String>>(() {
  return CertificationFilterController();
});

/// The filtered list the grid renders: all certifications if no
/// filters selected, otherwise only those matching any selected
/// labelType.
final filteredCertificationListProvider =
    Provider<AsyncValue<List<Certification>>>((ref) {
  final certsAsync = ref.watch(certificationListProvider);
  final selectedTypes = ref.watch(certificationFilterControllerProvider);

  return certsAsync.whenData((certs) {
    if (selectedTypes.isEmpty) return certs;
    return certs.where((cert) => selectedTypes.contains(cert.labelType)).toList();
  });
});