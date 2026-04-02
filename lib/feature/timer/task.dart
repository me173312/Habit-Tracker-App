import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String name;

  @HiveField(1)
  String period;

  Task({required this.name, required this.period});
}
