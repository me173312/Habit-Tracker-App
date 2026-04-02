import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_track/service/const_varible.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthOperation {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _handleFirebaseAuthException(FirebaseAuthException e) {
    log(e.code);
    switch (e.code) {
      case 'weak-password':
        return Future.value('The password provided is too weak.');
      case 'email-already-in-use':
        return Future.value('The account already exists for that email.');
      case 'invalid-email':
        return Future.value('Invalid email address.');
      case 'user-not-found':
        return Future.value('User not found.');
      case 'wrong-password':
        return Future.value('Wrong password.');
      case 'too-many-requests':
        return Future.value('Too many requests. Please try again later.');
      case 'invalid-credential':
        return Future.value(' Password or emial incorrect');
      case 'operation-not-allowed':
        return Future.value('Operation not allowed.');
      case 'network-request-failed':
        return Future.value(
            'Network request failed. Please check your internet connection.');
      default:
        return Future.value(
            'An unexpected error occurred. Please try again later.');
    }
  }

  // Register
  Future<String> register(String emailAddress, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return "success";
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(e);
    } catch (e) {
      return e.toString();
    }
  }

  // Sign in
  Future<String> signIn(String emailAddress, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(e);
    } catch (e) {
      return e.toString();
    }
  }

  // Forget password
  Future<String> forgetPassword(String emailAddress) async {
    try {
      await _auth.sendPasswordResetEmail(email: emailAddress);
      return "success";
    } on FirebaseAuthException catch (e) {
      return (e.code == 'user-not-found')
          ? 'No user found for that email.'
          : 'An unexpected error occurred. Please try again later.';
    } catch (e) {
      return e.toString();
    }
  }

  // Get user data
  Future<void> getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('user_info').doc(user.uid).get();

      if (userDoc.exists) {
        userName = userDoc.get('name');
        userEmial = user.email;
      }
    }
  }

  // Update user data
  Future<String> updateUserData({
    required String name,
    required String newEmail,
  }) async {
    User? user = _auth.currentUser;

    try {
      await user?.reload();
      user = _auth.currentUser;

      if (user!.emailVerified) {
        await _firestore.collection('user_info').doc(user.uid).update({
          'email': newEmail,
          'name': name,
        });
        return "success";
      } else {
        return "Verification required.";
      }
    } catch (e) {
      log(e.toString());
      return "unsuccess";
    }
  }

  signInwithGoogle() async {
    // Implement Google Sign-In here
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
