import 'package:flutter/material.dart';
import 'package:habit_track/core/global/global_widget/app_snackbar.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_button.dart';
import 'package:habit_track/feature/home/cubit/home_cubit/home_cubit.dart';
import 'package:habit_track/feature/home/cubit/goal_cubit/cubit/goal_cubit.dart';
import 'package:habit_track/feature/home/ui/widget/alert_widget/compont_widget_fort_alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';

class CreateNewGoal extends StatefulWidget {
  const CreateNewGoal({super.key});

  @override
  State<CreateNewGoal> createState() => _CreateNewGoalState();
}

class _CreateNewGoalState extends State<CreateNewGoal> {
  TextEditingController goalNameControllar = TextEditingController();
  String? selectedHabitName;
  String? habitId;
  String selectedHabitType = '';
  int? habitDays; // Variable to store the period as an integer

  @override
  void initState() {
    super.initState();
    //!git all habit
    context.read<GoalCubit>().getAllHabitInSystem();
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
              //! Top part
              const TopPartInAlert(
                nameOfAlert: 'Create New Goal',
              ),
              const SizedBox(height: 10),

              const Divider(color: Colors.black, thickness: .15),
              const SizedBox(height: 10),

              //! Goal name input
              TextPartInAlert(
                habitNameController: goalNameControllar,
                hintText: 'Goal Name',
              ),
              const SizedBox(height: 15),

              //! Habit name dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Habit Name",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<GoalCubit, GoalState>(
                    builder: (context, state) {
                      if (state is GetHabitForGoalSucsess) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8)),
                          child: DropdownButtonFormField<String>(
                            dropdownColor: Colors.grey[200],
                            value: selectedHabitName,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedHabitName = newValue;
                              });
                            },
                            items:
                                state.habitData.map<DropdownMenuItem<String>>(
                              (HabitModel habit) {
                                return DropdownMenuItem<String>(
                                  value: habit.name,
                                  onTap: () {
                                    habitId = habit.habitId;
                                  },
                                  child: Text(habit.name),
                                );
                              },
                            ).toList(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              size: 30,
                            ),
                          ),
                        );
                      } else if (state is GetHabitForGoaFail) {
                        return const Text('Failed to load habits');
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),

              //! Period input (user can enter custom period)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Period (Days)",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter days',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            habitDays = int.tryParse(value); // Convert to int
                          } else {
                            habitDays = null;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              //! Create button
              BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is CreatGoalFail) {
                    Navigator.pop(context);
                    AppStuts.showCustomSnackBar(
                        context, "Error", Icons.close, false);
                  } else if (state is CreatGoalSucsses) {
                    Navigator.pop(context);
                    AppStuts.showCustomSnackBar(
                        context, "Create Goal successful", Icons.check, true);
                  }
                },
                builder: (context, state) {
                  return state is CreatGoalLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          buttonName: 'Create',
                          onPressed: () {
                            if (habitDays != null && habitDays! > 0) {
                              context.read<HomeCubit>().creatGoal(
                                  name: goalNameControllar.text,
                                  period: habitDays!,
                                  habitId: habitId);
                            } else {
                              AppStuts.showCustomSnackBar(
                                  context,
                                  "Please enter a valid number of days",
                                  Icons.close,
                                  false);
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
