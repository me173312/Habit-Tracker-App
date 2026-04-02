import 'package:flutter/material.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/core/theme/style.dart';

class CustomText extends StatelessWidget {
  final String hintName;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  const CustomText({
    super.key,
    required this.hintName,
    this.hintText,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintName,
          style: TextAppStyle.subTittel,
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          color: Colors.white,
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: decorationField(habitHintName: hintText),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}

OutlineInputBorder borderTextField() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(
      color: AppColor.borderColor,
      width: 1.0,
    ),
  );
}

InputDecoration decorationField({String? habitHintName}) {
  return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      border: borderTextField(),
      hintText: habitHintName,
      hintStyle: TextAppStyle.subTittel,
      enabledBorder: borderTextField(),
      focusedBorder: borderTextField(),
      errorBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)));
}
