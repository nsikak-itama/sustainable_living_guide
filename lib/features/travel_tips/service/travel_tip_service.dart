import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/travel_tip_model.dart';

class TravelTipService {
  final FirebaseFirestore _firestore;

  TravelTipService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<TravelTip>> getAllTips() async {
    final snapshot = await _firestore.collection('travelTips').get();
    return snapshot.docs
        .map((doc) => TravelTip.fromMap(doc.id, doc.data()))
        .toList();
  }
}