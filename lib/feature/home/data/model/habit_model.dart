import 'dart:developer';

class ProgressModel {
  bool completed; // If the habit was completed on that date

  ProgressModel({
    required this.completed,
  });

  // Factory method to create ProgressModel from JSON
  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      completed: json['completed'] as bool,
    );
  }

  // Convert ProgressModel back to JSON
  Map<String, dynamic> toJson() {
    return {
      'completed': completed,
    };
  }
}

class Goal {
  String? name;
  int? total;
  int? currentProgress;
  String? habitId;
  Goal({this.name, this.total, this.currentProgress, this.habitId});

  Goal.fromJson(Map<String, dynamic> json) {
    name = json['goal_name'];
    total = json['total_day'];
    currentProgress = json['done_day'];
    habitId = json['habit_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['total'] = this.total;
    data['progress'] = this.currentProgress;
    return data;
  }
}

class HabitModel {
  String name;
  String period; // Period can be "daily" or "custom"
  List<String> customDays; // List of specific days if period is custom
  List<ProgressModel>? progress; // List of progress records
  String habitId;
  Goal? goal;

  HabitModel({
    required this.name,
    required this.period,
    required this.customDays,
    required this.habitId,
    this.goal,
    this.progress, // Initialize progress
  });

  // Factory method to create HabitModel from JSON
  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
        name: json['habit_name'] as String,
        habitId: json['habit_id'] as String,
        period: json['period'] as String,
        customDays: List<String>.from(json['customDays'] as List),
        goal: json['goal'] != null ? Goal.fromJson(json['goal']) : null
        // Map progress records
        );
  }

  // Convert HabitModel back to JSON
}
