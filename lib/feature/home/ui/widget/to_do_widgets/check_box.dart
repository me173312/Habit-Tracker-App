import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/theme/color.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool>
      onChanged; //s a type definition for a callback function that takes a bool and returns nothing.

  const CustomCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(
            !isChecked); // The onChanged function will be defined in the parent widget (HabitContiner) and passed to the child widget (CustomCheckbox).
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isChecked
              ? const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColor.checkBoxDoneHabitColor,
                    AppColor.secondCheckBoxDoneHabitColor,
                  ],
                )
              : null, // No gradient if unchecked
          borderRadius: BorderRadius.circular(10),
          border: isChecked
              ? null
              : Border.all(color: Colors.black), // Border for unchecked state
        ),
        padding: const EdgeInsets.all(4.0),
        child: isChecked
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              )
            : SizedBox(
                width: 16.w,
                height: 16.h,
              ),
      ),
    );
  }
}
