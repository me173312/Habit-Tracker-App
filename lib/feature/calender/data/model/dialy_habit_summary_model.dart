class HabitDialySummaryModel {
  List<String> allHabit; // List of all habit IDs
  List<String> notDoneHabit; // List of habit IDs that are not completed

  // Constructor
  HabitDialySummaryModel({
    required this.allHabit,
    required this.notDoneHabit,
  });

  // Factory method to create a DailySummary object from Firestore document data
  factory HabitDialySummaryModel.fromMap(Map<String, dynamic> data) {
    return HabitDialySummaryModel(
      allHabit: List<String>.from(data['allHabit'] ?? []),
      notDoneHabit: List<String>.from(data['notDoneHabit'] ?? []),
    );
  }
}
