import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_track/feature/home/cubit/home_cubit/home_cubit.dart';
import 'package:habit_track/feature/home/data/goal_firebase_operation.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:meta/meta.dart';

part 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  GoalCubit() : super(GoalInitial());
  GoalFirebaseOperation firebaseGoalOperation = GoalFirebaseOperation();
  // List<Goal> goalList = [];
  getAllHabitInSystem() async {
    try {
      List<HabitModel> result =
          await firebaseGoalOperation.getAllHabitInSystem();

      emit(GetHabitForGoalSucsess(habitData: result));
    } on Exception catch (e) {
      emit(GetHabitForGoaFail());
    }
  }

  @override
  void onChange(Change<GoalState> change) {
    // TODO: implement onChange
    log("==============");
    log(change.toString());
    super.onChange(change);
  }
}
