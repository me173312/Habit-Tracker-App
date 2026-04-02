import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/home/cubit/home_cubit/home_cubit.dart';
import 'package:habit_track/feature/home/data/model/habit_model.dart';
import 'package:habit_track/feature/home/ui/widget/to_do_widgets/habit_continer.dart';

class TabBarToDo extends StatefulWidget {
  final bool showAll; // Pass showAll state from parent

  const TabBarToDo({super.key, required this.showAll});

  @override
  State<TabBarToDo> createState() => _TabBarToDoState();
}

class _TabBarToDoState extends State<TabBarToDo> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: "To do" and "Not to do"
      child: Container(
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.white.withOpacity(.5),
            bottom: TabBar(
              unselectedLabelStyle: TextAppStyle.subTittel.copyWith(
                fontSize: 14.sp,
              ),
              unselectedLabelColor: AppColor.subText,
              labelColor: Colors.black,
              labelStyle: TextAppStyle.mainTittel.copyWith(fontSize: 25.sp),
              indicatorColor: Colors.white,
              dividerColor: Colors.white,
              tabs: [
                Tab(
                  height: 50.h,
                  text: 'To Do',
                ),
                Tab(
                  height: 50.h,
                  text: 'Uncomplete',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //! Widget 1: To Do Habits List
              BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
                final habitData = context.read<HomeCubit>().toDohabitList;
                if (state is HomeInitial) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  int habitCount = widget.showAll
                      ? habitData.length
                      : habitData.length >= 2
                          ? habitData.length
                          : 1;

                  return habitData.isEmpty
                      ? Center(
                          child: Text(
                            "No habits yet!",
                            style: TextAppStyle.subMainTittel.copyWith(
                              fontSize: 18.sp,
                              color: AppColor.subText,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: habitCount,
                          itemBuilder: (context, index) {
                            return HabitContiner(
                              index: index,
                              habitDate: habitData[index],
                            );
                          },
                        );
                }
              }),

              //! Widget 2: Not To Do Habits List with Animation
              BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is DoneHabitSuscsses) {
                    final notToDoHabits =
                        context.read<HomeCubit>().notToDohabitList;
                    if (notToDoHabits.isNotEmpty) {
                      // Remove the last item from the list with animation
                      final index = state.index;
                      final removedHabit = notToDoHabits.removeAt(index);
                      _listKey.currentState?.removeItem(
                        index,
                        (context, animation) =>
                            _buildRemovedItem(removedHabit, animation, index),
                        duration: const Duration(milliseconds: 300),
                      );
                    }
                  }
                },
                builder: (context, state) {
                  final notToDoHabits =
                      context.read<HomeCubit>().notToDohabitList;
                  return notToDoHabits.isEmpty
                      ? Center(
                          child: Text(
                            "All habits completed!",
                            style: TextAppStyle.subMainTittel.copyWith(
                              fontSize: 18.sp,
                              color: AppColor.subText,
                            ),
                          ),
                        )
                      : AnimatedList(
                          key: _listKey,
                          initialItemCount: notToDoHabits.length,
                          itemBuilder: (context, index, animation) {
                            return _buildAnimatedItem(
                                notToDoHabits[index], animation, index);
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

  Widget _buildAnimatedItem(
      HabitModel habit, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: HabitContiner(
        habitDate: habit,
        index: index,
      ),
    );
  }

  Widget _buildRemovedItem(
      HabitModel habit, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: HabitContiner(habitDate: habit, index: index),
      ),
    );
  }
}
