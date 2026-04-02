import 'package:flutter/material.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_text.dart';

class TopPartInAlert extends StatelessWidget {
  const TopPartInAlert({super.key, required this.nameOfAlert});
  final String nameOfAlert;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          nameOfAlert,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          child: const Icon(Icons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class TextPartInAlert extends StatelessWidget {
  const TextPartInAlert(
      {super.key,
      required this.habitNameController,
      required this.hintText,
      this.hintHabiText});
  final TextEditingController habitNameController;
  final String hintText;
  final String? hintHabiText;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${hintText} :",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        const SizedBox(height: 4),
        TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty'; // Return error message if the field is empty
              }
              return null; // Return null if the field is valid
            },
            controller: habitNameController,
            decoration: decorationField(habitHintName: hintHabiText)),
      ],
    );
  }
}

class CustomHabitDay extends StatefulWidget {
  final Function(List<String>) onDaysSelected;
  final List<String> initialSelectedDays;

  CustomHabitDay({
    super.key,
    required this.onDaysSelected,
    required this.initialSelectedDays,
  });

  @override
  State<CustomHabitDay> createState() => _CustomHabitTypeState();
}

class _CustomHabitTypeState extends State<CustomHabitDay> {
  final List<bool> selectedWeekdays = List.filled(7, false);
  final List<String> weekdays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  @override
  void initState() {
    super.initState();

    // Initialize selectedWeekdays based on initialSelectedDays what name choose
    for (int i = 0; i < weekdays.length; i++) {
      if (widget.initialSelectedDays.contains(weekdays[i])) {
        selectedWeekdays[i] = true;
      }
    }
  }

  void _notifyDaysSelected() {
    List<String> selectedDays = [];
    for (int i = 0; i < selectedWeekdays.length; i++) {
      if (selectedWeekdays[i]) {
        selectedDays.add(weekdays[i]);
      }
    }
    widget.onDaysSelected(selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(weekdays.length, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedWeekdays[index] = !selectedWeekdays[index];
            });
            _notifyDaysSelected();
          },
          child: Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: selectedWeekdays[index]
                      ? const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColor.checkBoxDoneHabitColor,
                            AppColor.secondCheckBoxDoneHabitColor,
                          ],
                        )
                      : null,
                  border: selectedWeekdays[index]
                      ? null
                      : Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: selectedWeekdays[index]
                    ? const Icon(Icons.check, color: Colors.white)
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 5),
              Text(
                weekdays[index].substring(0, 3),
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }),
    );
  }
}
