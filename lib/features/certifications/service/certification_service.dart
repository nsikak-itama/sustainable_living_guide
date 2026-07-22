import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/certification_model.dart';

class CertificationService {
  final FirebaseFirestore _firestore;

  CertificationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches every certification in the guide. Read-only — content
  /// is added/edited manually via Firebase Console.
  Future<List<Certification>> getAllCertifications() async {
    final snapshot = await _firestore.collection('certifications').get();

    return snapshot.docs
        .map((doc) => Certification.fromMap(doc.id, doc.data()))
        .toList();
  }
}