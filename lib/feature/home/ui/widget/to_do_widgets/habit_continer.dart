import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/feature/home/cubit/home_cubit/home_cubit.dart';
import 'package:habit_track/feature/home/data/home_firebase_operation.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:habit_track/feature/home/ui/widget/alert_widget/edit_alert.dart';
import 'package:habit_track/feature/home/ui/widget/to_do_widgets/check_box.dart';
import 'package:habit_track/main.dart';

class HabitContiner extends StatefulWidget {
  const HabitContiner(
      {super.key, required this.habitDate, required this.index});
  final HabitModel habitDate;
  final int index;
  @override
  State<HabitContiner> createState() => _HabitContinerState();
}

class _HabitContinerState extends State<HabitContiner> {
  late bool isChecked;
  final FirebaseHomeOperation f = FirebaseHomeOperation();

  @override
  //! to check if habit is completed
  //! initState is called only when the state is first inserted in the widget tree. Later on, it's the
  void initState() {
    if (widget.habitDate.progress!.isNotEmpty) {
      isChecked = widget.habitDate.progress![0].completed;
    } else {
      isChecked = false;
    }
    super.initState();
  }

//! didUpdateWidget which handles the subsequent calls.
  @override
  void didUpdateWidget(covariant HabitContiner oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update isChecked if the habitDate changes in the parent
    if (oldWidget.habitDate != widget.habitDate) {
      setState(() {
        isChecked = widget.habitDate.progress?.isNotEmpty == true
            ? widget.habitDate.progress![0].completed
            : false;
      });
    }
  }

  void showEditHabitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return EditHabitDialog(
          habitDate: widget.habitDate,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity, // Adjust as needed
            height: 50.h, // Adjust height
            decoration: BoxDecoration(
              color: isChecked
                  ? AppColor.backgroundHabitDon
                  : AppColor
                      .backGroundNotDoneHabit, // Toggle color based on state
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.habitDate.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: isChecked
                          ? AppColor.doneHabitTextColor
                          : Colors.black, // Green text color
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      CustomCheckbox(
                        isChecked: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value; // Update the state
                          });
                          context.read<HomeCubit>().updateDoneHabit(
                              habitId: widget.habitDate.habitId,
                              index: widget.index,
                              isComplet: value);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        color: Colors.grey,
                        onPressed: () {
                          showEditHabitDialog(context); // Show the dialog
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
