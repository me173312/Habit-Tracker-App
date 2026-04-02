import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_track/core/theme/screen_size.dart';
import 'package:habit_track/feature/home/cubit/home_cubit/home_cubit.dart';
import 'package:habit_track/feature/home/ui/widget/alert_widget/add_habit_alert.dart';
import 'package:habit_track/feature/home/ui/widget/card_progress.dart';
import 'package:habit_track/feature/home/ui/widget/goal_widget.dart';
import 'package:habit_track/feature/home/ui/widget/todo_widget.dart';
import 'package:habit_track/feature/home/ui/widget/top_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopPge(),
            AppScreenUtil.hight(12),
            const ProgressCard(),
            const ToDoWidget(),
            const GoalWidget()
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF008eba),
              Color(0xFF01b1d8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            _showAlertDialog(context);
          },
          elevation: 0, // Remove shadow to blend with gradient
          backgroundColor: Colors
              .transparent, // Set background to transparent to show the gradient
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CreateNewHabit();
      },
    );
  }
}
