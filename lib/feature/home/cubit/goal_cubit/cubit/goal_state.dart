part of 'goal_cubit.dart';

@immutable
sealed class GoalState {}

final class GoalInitial extends GoalState {}

final class GetHabitForGoaLoading extends GoalState {}

final class GetHabitForGoalSucsess extends GoalState {
  List<HabitModel> habitData;
  GetHabitForGoalSucsess({required this.habitData});
}

final class GetHabitForGoaFail extends GoalState {}

// final class DeleteGoalLoad extends GoalState {}

// final class DeleteGoalSuccsess extends GoalState {}

// final class DeleteGoalFail extends GoalState {}

// final class CreatGoalLoading extends GoalState {}

// final class CreatGoalSucsses extends GoalState {}

// final class CreatGoalFail extends GoalState {}
