import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/core/theme/screen_size.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/calender/cubit/cubit/calender_cubit.dart';
import 'package:habit_track/feature/calender/data/firebase_operation_calender.dart';
import 'package:habit_track/feature/calender/ui/screen/habit_detials_screen.dart';

class HabitCalendar extends StatefulWidget {
  @override
  _HabitCalendarState createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  EventList<Event> habitStatusMap = EventList<Event>(events: {});
  FirebaseOperationCalender f = FirebaseOperationCalender();
  @override
  void initState() {
    super.initState();
    _loadHabitData(); // Load habit data on initialization
  }

  Future<void> _loadHabitData() async {
    final dailyProgress =
        await f.lodaAllDateHabit(); // Fetch data from Firestore
    setState(() {
      habitStatusMap = EventList<Event>(events: dailyProgress);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now(); // Get current day

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${today.day}-${today.month}- ${today.year}",
                style: TextAppStyle.subTittel,
              ),
              const Text("Journaling everyday",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          Container(
            height: AppScreenUtil.getResponsiveHeight(context, .46),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CalendarCarousel<Event>(
              todayButtonColor: habitStatusMap.events[today] == null
                  ? Colors.blue
                  : Colors.transparent,
              markedDatesMap: habitStatusMap,
              markedDateShowIcon: true,
              markedDateIconMaxShown: 1,
              markedDateIconBuilder: (event) => _getDayDecoration(event.date),
              onDayPressed: (DateTime date, List<Event> events) {
                if (events.isNotEmpty) {
                  _navigateToHabitDetailsPage(context, date);
                } else {
                  _showNoHabitAlert(context, date);
                }
              },
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.blue, "Current Day"),
              const SizedBox(width: 10),
              _buildLegendItem(
                  const Color.fromARGB(255, 147, 221, 149), "Completed"),
              const SizedBox(width: 10),
              _buildLegendItem(Colors.red, "Incomplete"),
            ],
          ),
        ],
      ),
    );
  }

  // Get decoration for the day based on whether it's today, completed, or incomplete
  Widget? _getDayDecoration(DateTime date) {
    DateTime today = DateTime.now();

    // If it's today, highlight in blue
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return buildCircularDayDecoration(
          date.day, Colors.blue); // Blue for today
    } else if (habitStatusMap.getEvents(date).isNotEmpty) {
      return habitStatusMap
          .getEvents(date)[0]
          .icon; // Use the icon for completed/incomplete
    } else {
      return buildCircularDayDecoration(
          date.day, Colors.red); // Red for incomplete
    }
  }

  // Build a small legend item with circular color and text
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Navigate to a new screen that shows habit details for the selected day
  void _navigateToHabitDetailsPage(BuildContext context, DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailsPage(date: date),
      ),
    );
  }

  // Show an alert when no habit data is found for the selected date
  void _showNoHabitAlert(BuildContext context, DateTime date) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Habit Found"),
          content: Text(
              "No habit data available for ${date.day}-${date.month}-${date.year}."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
