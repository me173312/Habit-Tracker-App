import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/global/global_widget/app_snackbar.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_button.dart';
import 'package:habit_track/feature/home/cubit/home_cubit/home_cubit.dart';
import 'package:habit_track/feature/home/ui/widget/alert_widget/compont_widget_fort_alert.dart';

class CreateNewHabit extends StatefulWidget {
  const CreateNewHabit({super.key});

  @override
  State<CreateNewHabit> createState() => _CreateNewHabitState();
}

class _CreateNewHabitState extends State<CreateNewHabit> {
  TextEditingController habitNameController = TextEditingController();
  String selectedHabitType = 'Everyday';
  final List<String> customDays = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //!top part
              const TopPartInAlert(
                nameOfAlert: 'Create New Habit',
              ),
              const SizedBox(height: 10),

              const Divider(color: Colors.black, thickness: .15),
              const SizedBox(height: 10),

              Center(
                child: Text(
                  "Challange Your Self ",
                  style: TextAppStyle.subMainTittel.copyWith(
                    fontSize: 18.sp,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color(0xFF08D9D6), // #08D9D6
                          Color(0xFF0083B0), // #0083B0
                        ],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //!what name habit and text
              Form(
                key: formKey, // Wrap the TextPartInAlert in a Form
                child: TextPartInAlert(
                  habitNameController: habitNameController,
                  hintText: 'Habit Name',
                ),
              ),
              const SizedBox(height: 15),
              //!drop dwon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Habit Type",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Container(
                    width: 180,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.grey[200],
                      value: selectedHabitType,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedHabitType = newValue!;
                        });
                      },
                      items: <String>['Everyday', 'Custom']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              //!custom weekly
              if (selectedHabitType == 'Custom')
                CustomHabitDay(
                  onDaysSelected: (selectedDays) {
                    customDays.clear();
                    customDays.addAll(selectedDays);
                  },
                  initialSelectedDays: [],
                ),
              const SizedBox(height: 18),
              //!button update
              BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is creatHabiSuccses) {
                    Navigator.pop(context);
                    AppStuts.showCustomSnackBar(
                        context, "create habit succseful", Icons.check, true);
                  } else if (state is CreatHabiFail) {
                    Navigator.pop(context);

                    AppStuts.showCustomSnackBar(
                        context, "cant do habit", Icons.close, false);
                  }
                },
                builder: (context, state) {
                  return state is CreateHabitLoodin
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          buttonName: 'Create',
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              context.read<HomeCubit>().creatHabit(
                                    name: habitNameController.text,
                                    period: selectedHabitType,
                                    customDays: customDays,
                                  );
                            }
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CustomHabitType extends StatefulWidget {
//   final Function(List<String>) onDaysSelected;

//   CustomHabitType({super.key, required this.onDaysSelected});

//   @override
//   State<CustomHabitType> createState() => _CustomHabitTypeState();
// }

// class _CustomHabitTypeState extends State<CustomHabitType> {
//   final List<bool> selectedWeekdays = List.filled(7, false);
//   final List<String> weekdays = [
//     'Sunday',
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday'
//   ];

//   void _notifyDaysSelected() {
//     List<String> selectedDays = [];
//     for (int i = 0; i < selectedWeekdays.length; i++) {
//       if (selectedWeekdays[i]) {
//         selectedDays.add(weekdays[i]);
//       }
//     }
//     widget.onDaysSelected(selectedDays);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(weekdays.length, (index) {
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               selectedWeekdays[index] = !selectedWeekdays[index];
//             });
//             _notifyDaysSelected();
//           },
//           child: Column(
//             children: [
//               Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   gradient: selectedWeekdays[index]
//                       ? const LinearGradient(
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomLeft,
//                           colors: [
//                             AppColor.checkBoxDoneHabitColor,
//                             AppColor.secondCheckBoxDoneHabitColor,
//                           ],
//                         )
//                       : null,
//                   border: selectedWeekdays[index]
//                       ? null
//                       : Border.all(
//                           color: Colors.black,
//                           width: 2,
//                         ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: selectedWeekdays[index]
//                     ? const Icon(Icons.check, color: Colors.white)
//                     : const SizedBox.shrink(),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 weekdays[index].substring(0, 3),
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
