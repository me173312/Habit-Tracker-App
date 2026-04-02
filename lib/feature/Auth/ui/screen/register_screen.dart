import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_track/core/global/global_widget/app_snackbar.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/core/theme/screen_size.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/Auth/cubit/cubit/auth_cubit.dart';
import 'package:habit_track/feature/Auth/data/auth_operation.dart';
import 'package:habit_track/feature/Auth/ui/screen/login_screen.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_button.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_text.dart';
import 'package:habit_track/feature/Auth/ui/widget/googal_button.dart';
import 'package:habit_track/feature/Auth/ui/widget/password_field.dart';
import 'package:habit_track/feature/home/ui/screen/home_screen.dart';
import 'package:habit_track/feature/home/ui/screen/navbar.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  AuthOperation authFirebaseOperation = AuthOperation();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
          emial: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.h, left: 25.w, right: 25.w),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is AuthFaileRegister) {
              context.loaderOverlay.hide();
              AppStuts.showCustomSnackBar(
                  context, state.errorMassage, Icons.close, false);
            } else if (state is AuthRegisterSucsses) {
              //! if succsess get user data
              log("llll");
              await authFirebaseOperation.getUserData();
              context.loaderOverlay.hide();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()),
                (Route<dynamic> route) => false,
              );
            } else {
              context.loaderOverlay.show(
                widgetBuilder: (progress) {
                  return AppStuts.myLoading();
                },
              );
            }
          },
          //!body
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextAppStyle.mainTittel,
                      ),
                    ],
                  ),
                  AppScreenUtil.hight(10),
                  //!name text
                  CustomText(
                    hintName: 'Name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  AppScreenUtil.hight(10),
                  //!emial
                  CustomText(
                    hintName: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      // Check if the field is empty
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }

                      String pattern =
                          r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regex = RegExp(pattern);

                      if (!regex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                  ),

                  AppScreenUtil.hight(10),
                  //!pass
                  PasswordField(
                    hintName: 'Password',
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  AppScreenUtil.hight(10),
                  //!pass
                  PasswordField(
                    hintName: 'Password Confirmation',
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  AppScreenUtil.hight(20),
                  //!button
                  CustomButton(
                    buttonName: 'Sign Up',
                    onPressed: _onSignUp,
                  ),
                  AppScreenUtil.hight(20),
                  Text(
                    'Or sign up with:',
                    style: TextAppStyle.subTittel,
                  ),
                  AppScreenUtil.hight(10),

                  //!googal
                  GoogalButton(
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the text
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Already have an account?  ',
                            style: TextAppStyle
                                .subTittel, // Style for the normal text
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Login',
                                style: TextAppStyle.subTittel.copyWith(
                                  color: AppColor.primeColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> handleGoogleSignIn(BuildContext context) async {
  //   try {
  //     final userCredential = await AuthOperation().signInwithGoogle();
  //     if (userCredential != null) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const BottomNavBar()),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Google Sign-In was cancelled.'),
  //         ),
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     // Log the error and stack trace for debugging
  //     print('Google Sign-In Error: $e');
  //     print('Stack Trace: $stackTrace');

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Google Sign-In failed: $e'),
  //       ),
  //     );
  //   }
  // }
}
