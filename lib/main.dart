import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/feature/Auth/cubit/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_track/feature/home/cubit/home_cubit/home_cubit.dart';
import 'package:habit_track/feature/home/cubit/goal_cubit/cubit/goal_cubit.dart';

import 'package:habit_track/service/cash_helper.dart';
import 'package:habit_track/service/firebase_options.dart';
import 'package:habit_track/service/notfication_helper.dart';
import 'package:habit_track/splash_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:habit_track/feature/timer/task.dart';

import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CashNetwork.cashInitialization();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox('taskBox');
  await NotificationService.initFirebaseMessaging();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(
              create: (context) => HomeCubit()..getAllHabit(),
            ),
            BlocProvider<GoalCubit>(
              create: (context) => GoalCubit(),
            ),
            BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white.withOpacity(.988),
            ),
            home: splashScreen(),
          ),
        ),
      ),
    );
  }
}
/**
 * 
 *   جزء لو مش معانا مايظهرش في التقويم
 */