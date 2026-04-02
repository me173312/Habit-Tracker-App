import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_track/feature/Settings/screen/settting.dart';
import 'package:habit_track/feature/calender/ui/screen/calender_screen.dart';
import 'package:habit_track/feature/home/ui/screen/home_screen.dart';
import 'package:habit_track/feature/timer/timer_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with WidgetsBindingObserver {
  int curentIndex = 0;
  final screen = [
    const HomeScreen(),
    HabitCalendar(),
    TimerGoalScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF01b1d8),
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.white,
            child: BottomNavigationBar(
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
              backgroundColor: Colors.white.withOpacity(.89),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: _buildIconWithGradient(
                    icon: Icons.home_outlined,
                    isSelected: curentIndex == 0,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _buildIconWithGradient(
                    icon: Icons.calendar_month_rounded,
                    isSelected: curentIndex == 1,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _buildIconWithGradient(
                    icon: Icons.timer,
                    isSelected: curentIndex == 2,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _buildIconWithGradient(
                    icon: Icons.settings,
                    isSelected: curentIndex == 3,
                  ),
                  label: '',
                ),
              ],
              currentIndex: curentIndex,
              onTap: (value) => setState(() => curentIndex = value),
            ),
          ),
          body: screen[curentIndex],
        ),
      ),
    );
  }

  Widget _buildIconWithGradient(
      {required IconData icon, required bool isSelected}) {
    if (isSelected) {
      return ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [
              Color(0xFF008eba), // First gradient color
              Color(0xFF01b1d8), // Second gradient color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Icon(
          icon,
          size: 35,
          color: Colors.white, // This will be the mask color (icon visible)
        ),
      );
    } else {
      return Icon(icon);
    }
  }
}
