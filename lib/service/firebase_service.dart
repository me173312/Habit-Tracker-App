import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add  by own id or Update User Data
  Future<void> setData(
      {required String collection,
      required String documentId,
      required Map<String, dynamic> data}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(documentId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error setting data: $e');
    }
  }

  String getFirebaseUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }
}
