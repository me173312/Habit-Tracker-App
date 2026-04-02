import 'package:flutter/material.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/core/theme/screen_size.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:habit_track/feature/home/ui/widget/alert_widget/delete_goal_alert.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GoalContaner extends StatelessWidget {
  GoalContaner({
    super.key,
    required this.dateGoal,
  });
  final Goal dateGoal;
  void showEditHabitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DeletGoal(
            habitId: dateGoal.habitId!); // Use the new dialog widget
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.backGroundNotDoneHabit, // Toggle color based on state
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateGoal.name!,
              style: TextAppStyle.subMainTittel.copyWith(fontSize: 22),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LinearPercentIndicator(
                    animation: true,
                    width: AppScreenUtil.getResponsiveWidth(context, .7),
                    lineHeight: 10,
                    percent: (dateGoal.total != 0 && dateGoal.total != null)
                        ? (dateGoal.currentProgress! / dateGoal.total!)
                        : 0.0,
                    backgroundColor: AppColor.backGroundLinearProgress,
                    linearGradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColor.checkBoxDoneHabitColor,
                        AppColor.secondCheckBoxDoneHabitColor,
                      ],
                    )),
                InkWell(
                  onTap: () {
                    showEditHabitDialog(context);
                  },
                  child: const Icon(
                    Icons.delete_sharp,
                    color: Color.fromARGB(170, 158, 158, 158),
                  ),
                )
              ],
            ),
            Text(
              "${dateGoal.currentProgress} from ${dateGoal.total} days target",
              style: TextAppStyle.subTittel.copyWith(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
