import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_track/feature/home/data/model/notification_model.dart';
import 'package:habit_track/service/firebase_service.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class NotificationFirebaseOperation {
  FirebaseService firebaseService = FirebaseService();

  //set in firebase
  setNotfication({required String massageText}) async {
    String currentUserId = firebaseService.getFirebaseUserId();
    String formattedDateTime = DateFormat('d MMM HH:mm').format(DateTime.now());

    await FirebaseFirestore.instance
        .collection('user_info')
        .doc(currentUserId)
        .collection('notifcation')
        .doc()
        .set({
      'text': massageText,
      'date': formattedDateTime,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
    });
  }

  //get from fire base
  Future<List<NotificationModel>> getNotficationList() async {
    String currentUserId = firebaseService.getFirebaseUserId();

    // Reference to the user's notifications collection

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user_info')
        .doc(currentUserId)
        .collection('notifcation')
        .orderBy('timestamp', descending: true)
        .get();

    // Convert the documents to a list of maps
    List<NotificationModel> notficationList = [];

    for (var doc in querySnapshot.docs) {
      NotificationModel notfiData =
          NotificationModel.fromJson(doc.data() as Map<String, dynamic>);
      notficationList.add(notfiData);
    }

    return notficationList;
  }
}
