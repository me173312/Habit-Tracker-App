import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_track/core/global/global_widget/app_snackbar.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_button.dart';
import 'package:habit_track/feature/home/cubit/home_cubit/home_cubit.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:habit_track/feature/home/ui/widget/alert_widget/compont_widget_fort_alert.dart';
import 'package:habit_track/main.dart';

class EditHabitDialog extends StatefulWidget {
  EditHabitDialog({Key? key, required this.habitDate}) : super(key: key);
  HabitModel habitDate;

  @override
  State<EditHabitDialog> createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
  TextEditingController habitNameController = TextEditingController();
  String selectedHabitType = 'Everyday';
  List<String> customDays = [];

  @override
  void initState() {
    super.initState();

    habitNameController.text = widget.habitDate.name;
    if (widget.habitDate.period == 'Custom') {
      selectedHabitType = 'Custom';
      customDays = widget.habitDate.customDays ?? [];
    } else {
      selectedHabitType = 'Everyday';
    }
  }

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
                nameOfAlert: 'Edit Habit',
              ),
              const Divider(color: Colors.black, thickness: .15),
              const SizedBox(height: 10),
              //!what name habit and text
              TextPartInAlert(
                habitNameController: habitNameController,
                hintText: 'Habit Name',
                hintHabiText: widget.habitDate.name,
              ),
              const SizedBox(height: 15),
              //!drop down
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
                  initialSelectedDays:
                      customDays, // Pass initial custom days here
                  onDaysSelected: (selectedDays) {
                    customDays.clear();
                    customDays.addAll(selectedDays);
                  },
                ),
              const SizedBox(height: 18),
              //!button update
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return state is UpdateHabitLooding
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: AppColor.primeColor,
                        ))
                      : CustomButton(
                          buttonName: 'Update',
                          onPressed: () {
                            // Validation for custom habit type with empty custom days
                            if (selectedHabitType == 'Custom' &&
                                customDays.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please select at least one custom day"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return; // Prevent further execution if validation fails
                            }
                            context.read<HomeCubit>().updateHabitData(
                                  habitId: widget.habitDate.habitId,
                                  habitName: habitNameController.text.isEmpty
                                      ? widget.habitDate.name
                                      : habitNameController.text,
                                  period: selectedHabitType,
                                  customDays: customDays,
                                );
                          },
                        );
                },
              ),

              const SizedBox(height: 10),
              //!delete
              BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is DeleteHabitFail || state is UpdateHabitFail) {
                    Navigator.pop(context);
                    AppStuts.showCustomSnackBar(
                        context, "Error", Icons.close, false);
                  } else if (state is DeleteHabitSuscsses) {
                    Navigator.pop(context);

                    AppStuts.showCustomSnackBar(
                        context,
                        "${state.massage} '${widget.habitDate.name}' successful",
                        Icons.check,
                        true);
                  } else if (state is UpdateHabitSuscsses) {
                    Navigator.pop(context);

                    AppStuts.showCustomSnackBar(
                        context,
                        "${state.massage} '${habitNameController.text.isEmpty ? widget.habitDate.name : habitNameController.text}' successful",
                        Icons.check,
                        true);
                  }
                },
                builder: (context, state) {
                  return state is DeleteHabitLooding
                      ? const Center(child: CircularProgressIndicator())
                      : TextButton(
                          onPressed: () async {
                            await context
                                .read<HomeCubit>()
                                .deletHabit(habitId: widget.habitDate.habitId);
                          },
                          child: const Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
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
