import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:habit_track/feature/home/data/model/notification_model.dart';
import 'package:habit_track/feature/home/data/notification_firebase_operation.dart';
import 'package:meta/meta.dart';

part 'notfication_state.dart';

class NotficationCubit extends Cubit<NotficationState> {
  NotficationCubit() : super(NotficationInitial());
  NotificationFirebaseOperation firebaseNotficationOperation =
      NotificationFirebaseOperation();

  getNotfication() async {
    try {
      List<NotificationModel> result =
          await firebaseNotficationOperation.getNotficationList();

      emit(NotficationSuccses(notficationList: result));
    } on Exception catch (e) {
      emit(NotficationFail(errorMassage: e.toString()));
    }
  }
}
