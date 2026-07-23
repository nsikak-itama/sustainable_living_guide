import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/energy_tip_model.dart';

class EnergyTipService {
  final FirebaseFirestore _firestore;

  EnergyTipService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches every energy tip (Console-curated).
  Future<List<EnergyTip>> getAllTips() async {
    final snapshot = await _firestore.collection('energyTips').get();
    return snapshot.docs
        .map((doc) => EnergyTip.fromMap(doc.id, doc.data()))
        .toList();
  }
}