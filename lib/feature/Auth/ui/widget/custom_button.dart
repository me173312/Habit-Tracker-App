import 'package:flutter/material.dart';
import 'package:habit_track/core/theme/style.dart';

class CustomButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback? onPressed;
  final bool? isSend; // isSend is now final to ensure immutability

  const CustomButton({
    super.key,
    this.isSend = false, // Default is false
    required this.buttonName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Decide the background color based on isSend
    final backgroundColor = isSend == true
        ? const Color.fromARGB(255, 189, 188,
            188) // Set background color to grey if isSend is true
        : const LinearGradient(
            begin: Alignment(-0.75, -1.0),
            end: Alignment(1.0, 1.0),
            colors: [
              Color(0xFF0083B0),
              Color(0xFF00B4DB),
            ],
          ); // Default gradient

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: backgroundColor is LinearGradient ? backgroundColor : null,
        color: backgroundColor is Color
            ? backgroundColor
            : null, // Use color if backgroundColor is a solid color
      ),
      child: TextButton(
        onPressed: isSend == true
            ? null
            : onPressed, // Disable button if isSend is true
        child: Center(
          child: Text(
            buttonName,
            style: TextAppStyle.subTittel.copyWith(
                color: Colors.white, // Change text color if isSend is true
                fontSize: 20),
          ),
        ),
      ),
    );
  }
}
