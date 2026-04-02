import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/global/global_widget/app_snackbar.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/core/theme/screen_size.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/Auth/cubit/cubit/auth_cubit.dart';
import 'package:habit_track/feature/Auth/ui/screen/register_screen.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_button.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_text.dart';
import 'package:habit_track/main.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      log("Sending password reset instructions to: $email");
      context.read<AuthCubit>().forgetPassword(emial: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthForgetPasswordFail) {
          context.loaderOverlay.hide();

          AppStuts.showCustomSnackBar(
              context, state.errorMassage, Icons.close, false);
        } else if (state is AuthForgetPasswordSucsses) {
          context.loaderOverlay.hide();

          setState(() {
            _isEmailSent = true;
          });
          AppStuts.showCustomSnackBar(
              context,
              "Send Link to ${_emailController.text} successfully",
              Icons.check,
              true);
        } else {
          context.loaderOverlay.show(
            widgetBuilder: (progress) {
              return AppStuts.myLoading();
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Forget Password'),
          backgroundColor: AppColor.backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new), // The back icon
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Enter your email below, we will send instructions to reset your password",
                    style: TextAppStyle.subTittel,
                  ),
                  AppScreenUtil.hight(30),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: decorationField(),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  AppScreenUtil.hight(30),
                  CustomButton(
                    buttonName: _isEmailSent ? 'Check email' : 'Submit',
                    onPressed: _isEmailSent ? null : _handleSubmit,
                    isSend: _isEmailSent ? true : false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
