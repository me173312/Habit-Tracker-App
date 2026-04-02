import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_track/core/global/global_widget/app_snackbar.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/core/theme/screen_size.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_button.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_text.dart';
import 'package:habit_track/feature/Auth/ui/widget/password_field.dart';
import 'package:habit_track/feature/Auth/cubit/cubit/auth_cubit.dart';
import 'package:habit_track/service/const_varible.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void _onUpdate() {
    if (_formKey.currentState!.validate()) {
      String? nameControllar =
          _nameController.text.isEmpty ? userName : _nameController.text;
      String? emailController =
          _emailController.text.isEmpty ? userEmial : _emailController.text;

      context.read<AuthCubit>().verficationEmailFun(
          newEmail: emailController!,
          name: nameControllar!,
          password: _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Account'),
        backgroundColor: AppColor.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // The back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is UserVerificatiSuccses) {
              context.loaderOverlay.hide();
              AppStuts.showAwesomeSnackBar(
                context,
                ContentType.help,
                "check account",
              );
            }
            if (state is UpdateUserDataFail) {
              context.loaderOverlay.hide();
              AppStuts.showCustomSnackBar(
                  context, state.errorMessage, Icons.close, false);
            } else if (state is UpdateUserDataSuccsess) {
              context.loaderOverlay.hide();
              AppStuts.showCustomSnackBar(
                  context, "Update Succsufly", Icons.check, true);
              setState(() {});
              Navigator.pop(context);
            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomText(
                    hintName: "Name",
                    hintText: userName,
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  AppScreenUtil.hight(15),
                  CustomText(
                    hintName: "Email",
                    hintText: userEmial,
                    controller: _emailController,
                    validator: (value) {
                      // Define a regular expression for validating email
                      String pattern =
                          r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regex = RegExp(pattern);

                      // Allow empty value

                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }

                      // Check if the email is valid
                      if (!regex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                  ),
                  AppScreenUtil.hight(10),
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
                  AppScreenUtil.hight(25),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return CustomButton(
                        buttonName: state is UserVerificatiSuccses
                            ? 'Update'
                            : 'verfication Emial',
                        onPressed: _onUpdate,
                      );
                    },
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
