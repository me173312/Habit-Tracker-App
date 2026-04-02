import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_track/core/global/global_widget/app_snackbar.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/feature/Auth/ui/widget/custom_button.dart';
import 'package:habit_track/feature/Auth/ui/widget/password_field.dart';
import 'package:habit_track/feature/Auth/ui/widget/remmber_me.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _isLoading = false;

  // Function to re-authenticate user using the old password
  Future<void> _reauthenticateAndChangePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        setState(() {
          _isLoading = true;
        });

        //! Re-authenticate with old password
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _oldPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);

        //! Update password
        await user.updatePassword(_newPasswordController.text);
        AppStuts.showCustomSnackBar(
            context, 'Password changed successfully', Icons.check, true);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } on FirebaseAuthException catch (e) {
        //!error
        AppStuts.showCustomSnackBar(
            context, 'old Password Not Correct', Icons.close, false);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cahnge Password'),
        backgroundColor: AppColor.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // The back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PasswordField(
                hintName: 'Old Password',
                controller: _oldPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              PasswordField(
                hintName: 'New Password',
                controller: _newPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              RememberMeForgotPasswordRow(),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator(
                      color: AppColor.primeColor,
                    )
                  : CustomButton(
                      buttonName: 'Change Password',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _reauthenticateAndChangePassword();
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
