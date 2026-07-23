import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/content_model.dart';

class ContentService {
  final FirebaseFirestore _firestore;

  ContentService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<EducationalContent>> getAllContent() async {
    final snapshot = await _firestore.collection('educationalContent').get();
    return snapshot.docs
        .map((doc) => EducationalContent.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<Set<String>> getSavedContentIds(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('savedContent')
        .get();
    return snapshot.docs.map((doc) => doc.id).toSet();
  }

  Future<void> saveContent({required String uid, required String contentId}) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('savedContent')
        .doc(contentId)
        .set({'contentId': contentId, 'savedAt': DateTime.now()});
  }

  Future<void> unsaveContent({required String uid, required String contentId}) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('savedContent')
        .doc(contentId)
        .delete();
  }
}