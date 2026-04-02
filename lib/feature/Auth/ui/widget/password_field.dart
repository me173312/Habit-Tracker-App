import 'package:flutter/material.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/Auth/ui/screen/register_screen.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_text.dart';

class PasswordField extends StatefulWidget {
  final String hintName;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordField({
    required this.hintName,
    required this.controller,
    required this.validator,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.hintName,
          style: TextAppStyle.subTittel,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.white,
          child: TextFormField(
            controller: widget.controller,
            obscureText: _isObscured,
            validator: widget.validator,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              border: borderTextField(),
              enabledBorder: borderTextField(),
              focusedBorder: borderTextField(),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }


}