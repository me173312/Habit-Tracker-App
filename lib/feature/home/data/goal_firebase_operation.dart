import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:habit_track/service/firebase_service.dart';
import 'package:intl/intl.dart';

class GoalFirebaseOperation {
  FirebaseService firebaseService = FirebaseService();

  Future<bool> creeateGoal(
      {required String goalName,
      required int period,
      required String habitId}) async {
    String userId = firebaseService.getFirebaseUserId();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    bool isCompleted = false;
    try {
      DocumentSnapshot progressSnapshot = await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .collection('progress')
          .doc(todayDate) // Directly access the document by its ID (todayDate)
          .get();
      if (progressSnapshot.exists) {
        var habitData = progressSnapshot.data() as Map<String, dynamic>?;
        isCompleted = habitData!['completed'] as bool;
      }
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .update({
        'goal': {
          'goal_name': goalName,
          'total_day': period,
          'done_day': isCompleted ? 1 : 0,
          'habit_id': habitId
        }
      });

      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<List<HabitModel>> getAllHabitInSystem() async {
    String userId = firebaseService.getFirebaseUserId();
    List<HabitModel> habitsList = [];
    QuerySnapshot allHabits = await FirebaseFirestore.instance
        .collection('user_info')
        .doc(userId)
        .collection('habits')
        .get();
    for (var habit in allHabits.docs) {
      HabitModel habitData =
          HabitModel.fromJson(habit.data() as Map<String, dynamic>);
      habitsList.add(habitData);
    }
    return habitsList;
  }

  Future<bool> deleteGoal({required String habitId}) async {
    String userId = firebaseService.getFirebaseUserId();
    try {
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .update({
        'goal': FieldValue.delete(),
      });
      return true;
    } on Exception catch (e) {
      return false;
    }
  }
}
