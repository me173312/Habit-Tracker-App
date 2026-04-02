import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/Auth/ui/screen/register_screen.dart';
import 'package:habit_track/feature/Settings/screen/account.dart';
import 'package:habit_track/feature/Settings/screen/chang_password.dart';
import 'package:habit_track/feature/Settings/widget/delet_and_logout.dart';
import 'package:habit_track/feature/Settings/widget/notfication_widget.dart';
import 'package:habit_track/feature/Settings/widget/setting_widgets.dart';
import 'package:habit_track/feature/Settings/widget/top_page.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopSettingPage(),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Settings",
              style: TextAppStyle.subMainTittel.copyWith(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          //! edit profile
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountPage(),
                ),
              );
            },
            child: const SettingWidget(
              tittel: 'Edit Profile',
              icon: Icons.person_outline,
              show: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //! change password
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(),
                ),
              );
            },
            child: const SettingWidget(
              tittel: 'Change Password',
              icon: Icons.lock_outline,
              show: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //!notfication
          const NotficationWidget(),
          const SizedBox(
            height: 20,
          ),
          //!shar app
          InkWell(
            onTap: () {
              String sharedText =
                  r' "Make your mark, cast your vote." Share via habit track application';
              Share.share(sharedText);
            },
            child: const SettingWidget(
              tittel: 'Share App',
              icon: Icons.share,
              show: false,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //!logout
          InkWell(
            onTap: () {
              _showLogoutDialog(context);
            },
            child: const LogOutWidget(
              title: 'log Out',
              icon: Icons.logout_outlined,
              show: false,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //!delete account
          InkWell(
            onTap: () {
              _showDeletDialog(context);
            },
            child: const LogOutWidget(
              title: 'Delet Account',
              icon: Icons.delete_sharp,
              show: false,
            ),
          ),
        ],
      ),
    );
  }

//! logout dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text('Confirm Deletion',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                    (Route<dynamic> route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.message}')),
                  );
                }
              },
              child:
                  const Text('Sign Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

//!delete dialog
  void _showDeletDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_sharp, color: Colors.red),
              SizedBox(width: 10),
              Text('Confirm Deletion',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.(You will lose All Data)',
            style: TextStyle(fontSize: 16),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.currentUser!.delete();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                    (Route<dynamic> route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.message}')),
                  );
                }
              },
              child: const Text('Delet Account ',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
