import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/core/theme/screen_size.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/Auth/cubit/cubit/auth_cubit.dart';
import 'package:habit_track/service/const_varible.dart';

class TopSettingPage extends StatefulWidget {
  const TopSettingPage({super.key});

  @override
  State<TopSettingPage> createState() => _TopSettingPageState();
}

class _TopSettingPageState extends State<TopSettingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UpdateUserDataSuccsess) {
          setState(() {});
        }
      },
      builder: (context, state) {
        return Container(
          height: 110.h,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF009bc5),
                  Color(0xFF009bc5),
                  Color(0xFF0187b4),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  userName ?? "null",
                  style: TextAppStyle.subMainTittel.copyWith(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                AppScreenUtil.hight(4),
                Text(
                  userEmial ?? "jgrkg",
                  style: TextAppStyle.subTittel
                      .copyWith(fontSize: 18, color: Colors.black),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
