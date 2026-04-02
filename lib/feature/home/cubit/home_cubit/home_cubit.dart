import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habit_track/feature/home/data/goal_firebase_operation.dart';
import 'package:habit_track/feature/home/data/home_firebase_operation.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:habit_track/service/const_varible.dart';
import 'package:habit_track/service/notfication_helper.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  FirebaseHomeOperation firebaseHomeOperation = FirebaseHomeOperation();
  GoalFirebaseOperation firebaseGoalOperation = GoalFirebaseOperation();

  List<HabitModel> notToDohabitList = [];
  List<HabitModel> toDohabitList = [];

  List<Goal> goalList = [];
  double getPrecentage() {
    if (toDohabitList.isEmpty) {
      return 0;
    } else {
      double percentage = (toDohabitList.length - notToDohabitList.length) /
          toDohabitList.length;
      return double.parse(percentage.toStringAsFixed(2));
    }
  }

  bool isDayFinished() {
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(
        now.year, now.month, now.day, 23, 59, 59); // End of the day (midnight)
    return now.isAfter(midnight);
  }

  handelNotfication() {
    if (isNotificationEnabled!) {
      if (notToDohabitList.isEmpty && toDohabitList.isNotEmpty) {
        NotificationService.sendNotification(token!, "Congrats!",
            "🎉 You finished 100% of your habit for today! 🎯 ");
      } else if (isDayFinished() && notToDohabitList.isNotEmpty) {
        NotificationService.sendNotification(
          token!,
          "Reminder!",
          "😕 You did not finish all your habits today. You completed ${getPrecentage() * 100}% of your habits. Keep going! 💪 ",
        );
      }
    }
  }

//todo create habit

  creatHabit({
    required String name,
    required String period,
    required List<String> customDays,
  }) async {
    emit(CreateHabitLoodin());
    bool result = await firebaseHomeOperation.createHabit(
        habitName: name, period: period, customDays: customDays);
    if (result) {
      emit(creatHabiSuccses());
      await getAllHabit();
    } else {
      emit(CreatHabiFail());
    }
  }

  getAllHabit() async {
    try {
      List<HabitModel> result = await firebaseHomeOperation.getAllHabits();
      toDohabitList = result;
      await getUncompletHabit(result);
      await getAllGoal(result);
      // handelNotfication();
      log("all habit list");
      for (var element in toDohabitList) {
        log(element.name);
        log(element.progress![0].completed.toString());
      }
      log(toDohabitList.length.toString());
      emit(GetHabitSucsess());
    } on Exception catch (e) {
      emit(GetHabitFail(massage: e.toString()));
    }
  }

  creatGoal({
    required String name,
    required int period,
    required habitId,
  }) async {
    emit(CreatGoalLoading());
    bool result = await firebaseGoalOperation.creeateGoal(
        goalName: name, period: period, habitId: habitId);
    if (result) {
      emit(CreatGoalSucsses());
      await getAllHabit();
    } else {
      emit(CreatGoalFail());
    }
  }

  deleteGoal({required String habitId}) async {
    emit(DeleteGoalLoad());
    bool result = await firebaseGoalOperation.deleteGoal(habitId: habitId);
    if (result) {
      emit(DeleteGoalSuccsess());
      await getAllHabit();
    } else {
      emit(DeleteGoalFail());
    }
  }

  getAllGoal(List<HabitModel> result) {
    goalList.clear();

    for (int i = 0; i < result.length; i++) {
      if (result[i].goal != null) {
        //if (result[i].goal!.total! + 1 != result[i].goal!.currentProgress)
        goalList.add(result[i].goal!);
      }
    }
  }

  getUncompletHabit(List<HabitModel> result) async {
    log("enter to uncomplete");
    log("${result.length.toString()} result when enter fun uncomplete");

    List<HabitModel> not = [];

    try {
      for (int i = 0; i < result.length; i++) {
        if (result[i].progress!.isNotEmpty) {
          log("================");
          log(result[i].name);
          log(result[i].progress![0].completed.toString());
          log("================");

          if (!result[i].progress![0].completed) {
            not.add(result[i]);
          }
        }
      }
      notToDohabitList = not;
      log(notToDohabitList.length.toString());
    } on Exception catch (e) {
      emit(GetHabitFail(massage: e.toString()));
    }
  }

  updateDoneHabit(
      {required String habitId,
      required bool isComplet,
      required int index}) async {
    emit(DoneHabitLooding());
    bool result = await firebaseHomeOperation.markHabit(
        habitId: habitId, isComplet: isComplet);
    if (result) {
      emit(DoneHabitSuscsses(index: index));
      await getAllHabit();
    } else {
      emit(DoneHabitFail());
    }
  }

  deletHabit({required String habitId}) async {
    emit(DeleteHabitLooding());
    log(habitId);
    bool result = await firebaseHomeOperation.deletHabit(habitId: habitId);
    if (result) {
      emit(DeleteHabitSuscsses(massage: 'Delete'));
      await getAllHabit();
    } else {
      emit(DeleteHabitFail());
    }
  }

  updateHabitData(
      {required String habitId,
      required String habitName,
      required String period,
      required List<String> customDays}) async {
    emit(UpdateHabitLooding());
    bool result = await firebaseHomeOperation.updateHabitDate(
        habitId: habitId,
        habitName: habitName,
        period: period,
        customDay: customDays);
    if (result) {
      emit(UpdateHabitSuscsses(massage: 'Update'));
      await getAllHabit();
    } else {
      emit(UpdateHabitFail());
    }
  }

  @override
  void onChange(Change<HomeState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
