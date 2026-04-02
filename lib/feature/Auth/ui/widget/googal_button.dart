import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/feature/Auth/data/auth_operation.dart';
import 'package:habit_track/feature/home/ui/screen/navbar.dart';
import 'package:habit_track/service/firebase_service.dart';

class GoogalButton extends StatelessWidget {
  const GoogalButton({super.key, required this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            border: Border.all(
              color: AppColor.borderColor,
              width: 1.0,
            ),
          ),
          child: Center(child: Image.asset("assets/images/Group.png")),
        ),
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //   child: Container(
    //     width: double.infinity,
    //     height: 50.h,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(4),
    //       color: Colors.white,
    //       border: Border.all(
    //         color: AppColor.borderColor,
    //         width: 1.0,
    //       ),
    //     ),
    //     child: Center(child: Image.asset("assets/images/Group.png")),
    //   ),
    // );
  }
}
