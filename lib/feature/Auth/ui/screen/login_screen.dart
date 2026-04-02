import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/global/global_widget/app_snackbar.dart';
import 'package:habit_track/core/theme/screen_size.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/Auth/cubit/cubit/auth_cubit.dart';
import 'package:habit_track/feature/Auth/data/auth_operation.dart';
import 'package:habit_track/feature/Auth/ui/screen/register_screen.dart';

import 'package:habit_track/feature/Auth/ui/widget/custom_button.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_text.dart';
import 'package:habit_track/feature/Auth/ui/widget/googal_button.dart';
import 'package:habit_track/feature/Auth/ui/widget/password_field.dart';
import 'package:habit_track/feature/Auth/ui/widget/remmber_me.dart';
import 'package:habit_track/feature/home/ui/screen/navbar.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../core/theme/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthOperation authFirebaseOperation = AuthOperation();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().logIN(
          emial: _emailController.text, password: _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthFaileLogin) {
            context.loaderOverlay.hide();
            AppStuts.showCustomSnackBar(
                context, state.errorMassage, Icons.close, false);
          } else if (state is AuthLogInSucsses) {
            //!get user data
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
        child: Padding(
          padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Log In",
                        style: TextAppStyle.mainTittel,
                      ),
                    ],
                  ),
                  AppScreenUtil.hight(20),
                  //!emial
                  CustomText(
                    hintName: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  AppScreenUtil.hight(20),
                  //!passwword
                  PasswordField(
                    hintName: 'Password',
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  AppScreenUtil.hight(15),
                  RememberMeForgotPasswordRow(),
                  AppScreenUtil.hight(20),
                  //!button
                  CustomButton(
                    buttonName: 'Login',
                    onPressed: _handleLogin,
                  ),
                  AppScreenUtil.hight(30),
                  Text(
                    'Or log in with: ',
                    style: TextAppStyle.subTittel,
                  ),
                  AppScreenUtil.hight(15),
                  //!button
                  GoogalButton(
                    onTap: () {
                      handleGoogleSignIn();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the text
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account ? ",
                            style: TextAppStyle
                                .subTittel, // Style for the normal text
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign up',
                                style: TextAppStyle.subTittel.copyWith(
                                  color: AppColor.primeColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pop();
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

  Future<void> handleGoogleSignIn() async {
    try {
      final userCredential = await AuthOperation().signInwithGoogle();
      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Sign-In was cancelled.'),
          ),
        );
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: $e'),
        ),
      );
    }
  }
}
