import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:habit_track/service/firebase_service.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class FirebaseHomeOperation {
  FirebaseService firebaseService = FirebaseService();
//todo create habit
  Future<bool> createHabit({
    required String habitName,
    required String period,
    required List<String> customDays,
  }) async {
    String habitId = Uuid().v4();
    String currentUserId = firebaseService.getFirebaseUserId();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      // Habit data for the 'habits' collection
      var habitData = {
        'habit_id': habitId,
        'habit_name': habitName,
        'period': period,
        'customDays': customDays,
      };

      // Add habit data to the user's habits sub-collection
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(currentUserId)
          .collection('habits')
          .doc(habitId)
          .set(habitData, SetOptions(merge: true));

      // Create a progress document for the habit with default 'completed' status
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(currentUserId)
          .collection('habits')
          .doc(habitId)
          .collection('progress')
          .doc(todayDate)
          .set({'completed': false});

      // Update or create the daily summary for today
      var dailySummaryRef = FirebaseFirestore.instance
          .collection('user_info')
          .doc(currentUserId)
          .collection('dailySummary')
          .doc(todayDate);
//! put all habit in arrar (all habit) and also put in array notDoneHabit when it habit complet remove from (notDoneHabit)
      // Update daily summary by adding habitId to the 'totalHabits' array
      await dailySummaryRef.set({
        'allHabit': FieldValue.arrayUnion([
          habitId
        ]), //This is a special operation provided by Firestore to safely add values to an array field. and if found not  repewte
        'notDoneHabit': FieldValue.arrayUnion([habitId])
      }, SetOptions(merge: true));

      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

//todo mark habit
  Future<bool> markHabit(
      {required String habitId, required bool isComplet}) async {
    String currentUserId = firebaseService.getFirebaseUserId();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
//set if  user complet habit
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(currentUserId)
          .collection('habits')
          .doc(habitId)
          .collection('progress')
          .doc(todayDate)
          .set({'completed': isComplet});
//update goal if found goal for this habit
      DocumentSnapshot habitDoc = await FirebaseFirestore.instance
          .collection('user_info')
          .doc(currentUserId)
          .collection('habits')
          .doc(habitId)
          .get();
      if (habitDoc.exists) {
        // Check if the 'goal' field exists in the document
        var habitData = habitDoc.data() as Map<String, dynamic>?;
        if (habitData != null && habitData.containsKey('goal')) {
          // !Only update the goal if the 'goal' field exists
          await updateGoal(habitId: habitId, isComplet: isComplet);
        }
      }
      //!update dialy summary
      await updateDailySummary(habitId: habitId, isComplet: isComplet);
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

//todo update goal
  updateGoal({
    required String habitId,
    required bool isComplet,
  }) async {
    String currentUserId = firebaseService.getFirebaseUserId();

    try {
      if (isComplet) {
        //update goal if it complet by incrase done day 1
        await FirebaseFirestore.instance
            .collection('user_info')
            .doc(currentUserId)
            .collection('habits')
            .doc(habitId)
            .update({
          'goal.done_day': FieldValue.increment(1) // Increment done_day by 1
        });
      } else {
        //update goal if it complet by incrase done day 1
        await FirebaseFirestore.instance
            .collection('user_info')
            .doc(currentUserId)
            .collection('habits')
            .doc(habitId)
            .update({
          'goal.done_day': FieldValue.increment(-1) // decrement done_day by 1
        });
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

//todo update dialy summary
  Future<bool> updateDailySummary({
    required String habitId,
    required bool isComplet,
  }) async {
    String currentUserId = firebaseService.getFirebaseUserId();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      if (isComplet) {
        // If the habit is complete, remove the habitId from the 'notDoneHabit' array
        await FirebaseFirestore.instance
            .collection('user_info')
            .doc(currentUserId)
            .collection('dailySummary')
            .doc(todayDate)
            .set({
          'notDoneHabit': FieldValue.arrayRemove([habitId]),
          'allHabit': FieldValue.arrayUnion([habitId]), //not repet for sure
        }, SetOptions(merge: true));
      } else {
        // If the habit is not complete, add the habitId to the 'notDoneHabit' array if not already present
        await FirebaseFirestore.instance
            .collection('user_info')
            .doc(currentUserId)
            .collection('dailySummary')
            .doc(todayDate)
            .set({
          'notDoneHabit': FieldValue.arrayUnion([habitId]),
          'allHabit': FieldValue.arrayUnion([habitId]), //not repet for sure
        }, SetOptions(merge: true));
      }
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

//todo git all habit
  Future<List<HabitModel>> getAllHabits() async {
    List<HabitModel> habitsList = [];
    String userId = firebaseService.getFirebaseUserId();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String nameDay = DateFormat('EEEE').format(DateTime.now());

    try {
      //!get all habit custom day and evrday
      // First query for customDays containing nameDay
      QuerySnapshot customDaysSnapshot = await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('habits')
          .where('customDays', arrayContains: nameDay)
          .get();

      // Second query for period equal to 'Everyday'
      QuerySnapshot everydaySnapShot = await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('habits')
          .where('period', isEqualTo: 'Everyday')
          .get();

      // Combine both queries' results and remove duplicates
      List<QueryDocumentSnapshot> allDocuments = [
        ...customDaysSnapshot.docs,
        ...everydaySnapShot.docs,
      ];

      // Use a Set to remove duplicates by document ID
      var seenIds = <String>{};
      var uniqueDocuments = allDocuments
          .where((doc) => seenIds.add(doc.id))
          .toList(); //list of doc contian data each doc contian own data

//! convert each doc data to habit model(parse) and creat progress if not done (iscoompletfalse)

      for (var doc in uniqueDocuments) {
        HabitModel habit = await creatProgressHabit(doc, userId, todayDate);
        habitsList.add(habit);
      }
    } catch (e) {
      print('Error retrieving habits: $e');
    }

    return habitsList;
  }

//todo do parse for habit and create progress for this habit for special date and return habit parsing it progress done
  Future<HabitModel> creatProgressHabit(
    QueryDocumentSnapshot doc,
    String userId,
    String todayDate,
  ) async {
    // ! 1 Convert document data to HabitModel
    HabitModel habit = HabitModel.fromJson(doc.data() as Map<String, dynamic>);
//! 2 create progress for habit
    // Fetch progress sub-collection for each habit
    QuerySnapshot progressSnapshot = await FirebaseFirestore.instance
        .collection('user_info')
        .doc(userId)
        .collection('habits')
        .doc(doc.id) // Get the habit document ID
        .collection('progress')
        .where(FieldPath.documentId, isEqualTo: todayDate)
        .get();

    // Check if there's no progress document for today's date
    if (progressSnapshot.docs.isEmpty) {
      // No document found for today's date, create it with 'completed: false'
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('habits')
          .doc(doc.id)
          .collection('progress')
          .doc(todayDate) // Create the document with today's date as the ID
          .set({'completed': false});
    }

    // Create a list for the progress records
    List<ProgressModel> progressList = [];
    for (var progressDoc in progressSnapshot.docs) {
      ProgressModel progress =
          ProgressModel.fromJson(progressDoc.data() as Map<String, dynamic>);
      progressList.add(progress);
    }

    // Assign the progress records to the habit
    habit.progress = progressList;

    return habit;
  }

//!todo delet habit
  Future<bool> deletHabit({required String habitId}) async {
    String userId = firebaseService.getFirebaseUserId();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .delete();
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('dailySummary')
          .doc(todayDate)
          .update({
        'allHabit': FieldValue.arrayRemove([habitId]),
        'notDoneHabit': FieldValue.arrayRemove([habitId]),
      });
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

//todo update habit
  updateHabitDate(
      {required String habitId,
      required String habitName,
      required String period,
      required List<String> customDay}) async {
    String userId = firebaseService.getFirebaseUserId();

    try {
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .update({
        'habit_name': habitName,
        'period': period,
        'customDays': customDay
      });

      return true;
    } on Exception catch (e) {
      return false;
    }
  }
}
