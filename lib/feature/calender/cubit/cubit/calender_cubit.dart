import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:habit_track/feature/calender/data/firebase_operation_calender.dart';
import 'package:habit_track/feature/calender/data/model/dialy_habit_summary_model.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:meta/meta.dart';

part 'calender_state.dart';

class CalenderCubit extends Cubit<CalenderState> {
  CalenderCubit() : super(CalenderInitial());
  FirebaseOperationCalender firebaseOperation = FirebaseOperationCalender();

  getDateOfHabet({required String date}) async {
    emit(getHabitForSpacficDateLoadin());
    try {
      HabitDialySummaryModel result =
          await firebaseOperation.getHabitForSpacficDate(date: date);
      emit(getHabitForSpacficDateSuccses(dateOfHabit: result));
    } on Exception catch (e) {
      emit(getHabitForSpacficDateFail(massage: e.toString()));
    }
  }

  getSingleHabit({required String habitId}) async {
    HabitModel? result = await firebaseOperation.gettHabit(habitId: habitId);
    return result!.name;
  }

  @override
  void onChange(Change<CalenderState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
