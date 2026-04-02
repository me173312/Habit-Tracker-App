import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_track/feature/Auth/data/auth_operation.dart';
import 'package:habit_track/service/const_varible.dart';
import 'package:habit_track/service/firebase_service.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  AuthOperation authFirebaseOperation = AuthOperation();
  FirebaseService firebaseService = FirebaseService(); //set date in firebase
  bool customEmailVerified = false;

  //!register
  Future<void> register(
      {required String emial,
      required String password,
      required String name}) async {
    emit(AuthLoading());
    try {
      var result = await authFirebaseOperation.register(emial, password);
      if (result == "success") {
        String idUser = firebaseService.getFirebaseUserId();
        await setAuthUserData(email: emial, name: name, id: idUser);
        log("message");
        emit(AuthRegisterSucsses());
      } else {
        emit(AuthFaileRegister(errorMassage: result));
      }
    } on Exception catch (e) {
      emit(AuthFaileRegister(errorMassage: e.toString()));
    }
  }

  //!login
  Future<void> logIN({required String emial, required String password}) async {
    emit(AuthLoading());
    try {
      var result = await authFirebaseOperation.signIn(emial, password);

      if (result == "success") {
        emit(AuthLogInSucsses());
      } else {
        emit(AuthFaileLogin(errorMassage: result));
      }
    } on Exception catch (e) {
      emit(AuthFaileLogin(errorMassage: e.toString()));
    }
  }

//!set user data in firestore
  Future<void> setAuthUserData(
      {required String email, required String name, required String id}) async {
    try {
      var userData = {
        'email': email,
        'name': name,
        "id": id,
      };
      await firebaseService.setData(
          collection: 'user_info', data: userData, documentId: id);
    } catch (e) {
      log('Error storing user data: $e');
    }
  }

//!update user data
  void updateUserData({
    required String name,
    required String email,
  }) async {
    emit(UpdateUserDataLooding());
    if (name != userName || email != userEmial) {
      try {
        final result = await authFirebaseOperation.updateUserData(
          name: name,
          newEmail: email,
        );
        if (result == "success") {
          userName = name;
          userEmial = email;
          emit(UpdateUserDataSuccsess());
        } else if (result == 'Verification') {
          emit(UpdateUserDataFail(errorMessage: "check Your emial"));
        } else {
          emit(UpdateUserDataFail(errorMessage: "error"));
        }
      } on Exception catch (e) {
        emit(UpdateUserDataFail(errorMessage: e.toString()));
      }
    } else {
      emit(UpdateUserDataFail(errorMessage: "Same Data Can't Update"));
    }
  }

//! verfication emial
  verficationEmailFun(
      {required String newEmail,
      required String password,
      required String name}) async {
    emit(UserVerificationLoad());
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user!.reload();
      user = FirebaseAuth.instance.currentUser;
      if (!customEmailVerified) {
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        await user.verifyBeforeUpdateEmail(newEmail);
        emit(UserVerificatiSuccses());
      } else {
        updateUserData(email: newEmail, name: name);
        customEmailVerified = false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        emit(UpdateUserDataFail(errorMessage: "password not correct"));
      } else if (e.code == 'user-token-expired') {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: newEmail, password: password);
        customEmailVerified = true;
        verficationEmailFun(name: name, newEmail: newEmail, password: password);
      }
    } catch (e) {
      UpdateUserDataFail(errorMessage: "please tray Agin");
    }
  }

//!forget password
  Future<void> forgetPassword({required String emial}) async {
    emit(AuthForgetPasswordLoad());
    try {
      var result = await authFirebaseOperation.forgetPassword(emial);

      if (result == "success") {
        emit(AuthForgetPasswordSucsses());
      } else {
        emit(AuthForgetPasswordFail(errorMassage: result));
      }
    } on Exception catch (e) {
      emit(AuthForgetPasswordFail(errorMassage: e.toString()));
    }
  }

  @override
  void onChange(Change<AuthState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
