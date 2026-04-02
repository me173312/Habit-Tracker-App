import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/home/ui/widget/to_do_widgets/tapbar.dart';

class ToDoWidget extends StatefulWidget {
  const ToDoWidget({super.key});

  @override
  _ToDoWidgetState createState() => _ToDoWidgetState();
}

class _ToDoWidgetState extends State<ToDoWidget> {
  bool showAll = false; // Track whether to show all habits or just two

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: AnimatedContainer(
        // Dynamically adjust height
        duration: const Duration(milliseconds: 300), // Animation duration
        width: double.infinity,
        height: showAll ? 400.h : 220.h, // Increase height if showAll is true
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(57, 158, 158, 158), // Shadow color
              blurRadius: 10,
              offset: Offset(0, 8), // Horizontal and vertical offset
            ),
          ],
        ),
        child: Column(
          children: [
            //! 1: Pass the 'showAll' value to TabBarToDo
            Expanded(child: TabBarToDo(showAll: showAll)),
            //! 2: "Show More" Button
            TextButton(
              onPressed: () {
                setState(() {
                  showAll = !showAll; // Toggle between showing all and limited
                });
              },
              child: Text(
                showAll ? 'Show less' : 'Show more', // Update button text
                style: TextAppStyle.subTittel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
