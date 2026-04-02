import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_track/feature/calender/cubit/cubit/calender_cubit.dart';
import 'package:intl/intl.dart';

class HabitDetailsPage extends StatelessWidget {
  final DateTime date;

  HabitDetailsPage({required this.date});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalenderCubit()
        ..getDateOfHabet(date: DateFormat('yyyy-MM-dd').format(date)),
      child: BlocBuilder<CalenderCubit, CalenderState>(
        builder: (context, state) {
          if (state is getHabitForSpacficDateLoadin) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is getHabitForSpacficDateSuccses) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Top Title
                    const Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Progress Report and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress Report',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            DateFormat('MMM d').format(date),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Section: Your Goals
                    const Text(
                      'Summary Day',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Circular Progress Bar
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              value: (state.dateOfHabit.allHabit.length -
                                      state.dateOfHabit.notDoneHabit.length) /
                                  state.dateOfHabit.allHabit.length,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                          ),
                          Text(
                            '${(((state.dateOfHabit.allHabit.length - state.dateOfHabit.notDoneHabit.length) / state.dateOfHabit.allHabit.length) * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Achieved and Unachieved Habits Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          '${state.dateOfHabit.allHabit.length - state.dateOfHabit.notDoneHabit.length} Habits goal has achieved',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cancel, color: Colors.red, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          '${state.dateOfHabit.notDoneHabit.length} Habits goal hasn\'t achieved',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    // Goals List
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.dateOfHabit.allHabit.length,
                        itemBuilder: (context, index) {
                          // Extract habitId
                          final habitId = state.dateOfHabit.allHabit[index];

                          return FutureBuilder<dynamic>(
                            future: context
                                .read<CalenderCubit>()
                                .getSingleHabit(habitId: habitId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Show a loading indicator while the habit name is being fetched
                                return const ListTile(
                                  title: Text('Loading...'), // Placeholder text
                                  trailing: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                // Show error message in case of an error
                                return const ListTile(
                                  title: Text(
                                    'Delete this habit',
                                  ),
                                  trailing:
                                      Icon(Icons.error, color: Colors.red),
                                );
                              } else if (snapshot.hasData) {
                                // Once the data is fetched, display the habit name
                                String name = snapshot.data!;

                                return ListTile(
                                  title: Text(name),
                                  trailing: Icon(
                                    state.dateOfHabit.notDoneHabit
                                            .contains(habitId)
                                        ? Icons.cancel
                                        : Icons.check_circle,
                                    color: state.dateOfHabit.notDoneHabit
                                            .contains(habitId)
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                );
                              } else {
                                // In case data is null, show a fallback message
                                return const ListTile(
                                  title: Text('No habit data'),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),

                    // See All Text

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
