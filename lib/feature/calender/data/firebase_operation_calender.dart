import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/feature/calender/data/model/dialy_habit_summary_model.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:habit_track/service/firebase_service.dart';

class FirebaseOperationCalender {
  FirebaseService firebaseService = FirebaseService();

  Future<Map<DateTime, List<Event>>> lodaAllDateHabit() async {
    String userId = firebaseService.getFirebaseUserId();
    Map<DateTime, List<Event>> events = {};

    QuerySnapshot habitByDateSnapshot = await FirebaseFirestore.instance
        .collection('user_info')
        .doc(userId)
        .collection('dailySummary')
        .get();

    for (var habitDoc in habitByDateSnapshot.docs) {
      String docId = habitDoc.id; // The document ID represents the date
      DateTime date = DateTime.parse(docId); //convert to date
//for parse
      HabitDialySummaryModel data = HabitDialySummaryModel.fromMap(
          habitDoc.data() as Map<String, dynamic>);

      List<String> notDoneHabit = data.notDoneHabit; // Incomplete habits list

      // Check if all habits are
      bool isCompleted = notDoneHabit.isEmpty;
// notdone habit empty will be green
      if (isCompleted) {
        events[date] = [
          Event(
            date: date,
            icon: buildCircularDayDecoration(
              date.day,
              AppColor.secondCheckBoxDoneHabitColor,
            ),
          ),
        ];
      } else {
        // Red day (incomplete habits)
        events[date] = [
          Event(
            date: date,
            icon: buildCircularDayDecoration(date.day, Colors.red),
          ),
        ];
      }
    }

    return events;
  }

  getHabitForSpacficDate({required String date}) async {
    String userId = firebaseService.getFirebaseUserId();

    DocumentSnapshot habitByDateSnapshot = await FirebaseFirestore.instance
        .collection('user_info')
        .doc(userId)
        .collection('dailySummary')
        .doc(date)
        .get();

    HabitDialySummaryModel data = HabitDialySummaryModel.fromMap(
        habitByDateSnapshot.data() as Map<String, dynamic>);
    return data;
  }

  Future<HabitModel?> gettHabit({required String habitId}) async {
    String userId = firebaseService.getFirebaseUserId();

    try {
      DocumentSnapshot habitDataSnapshot = await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .get();
      HabitModel data =
          HabitModel.fromJson(habitDataSnapshot.data() as Map<String, dynamic>);

      return data;
    } on Exception catch (e) {
      return null;
    }
  }
}

Widget buildCircularDayDecoration(int day, Color color) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Text(
      "$day",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
