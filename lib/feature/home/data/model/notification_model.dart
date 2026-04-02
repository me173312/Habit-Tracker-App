class NotificationModel {
  String? text;
  String? date;
  NotificationModel({required this.text, required this.date
      // Initialize progress
      });

  // Factory method to create HabitModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      text: json['text'] as String,
      date: json['date'] as String,

      // Map progress records
    );
  }
}
