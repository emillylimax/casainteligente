// import 'package:cloud_firestore/cloud_firestore.dart';

// class StoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Atualizar o estado do LED
//   Future<void> updateLedState(bool isOn) async {
//     try {
//       await _firestore.collection('ledStatus').doc('led').set({'state': isOn ? 1 : 0});
//     } catch (e) {
//       throw Exception('Erro ao atualizar o estado do LED: $e');
//     }
//   }
//
//   // Monitorar o estado do LED em tempo real
//   Stream<bool> ledStateStream() {
//     return _firestore.collection('ledStatus').doc('led').snapshots().map((snapshot) {
//       final data = snapshot.data();
//       return data != null && data['state'] == 1;
//     });
//   }
// }
