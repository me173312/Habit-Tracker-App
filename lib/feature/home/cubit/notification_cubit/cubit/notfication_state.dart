part of 'notfication_cubit.dart';

@immutable
sealed class NotficationState {}

final class NotficationInitial extends NotficationState {}

final class NotficationLoad extends NotficationState {}

final class NotficationSuccses extends NotficationState {
  List<NotificationModel> notficationList;
  NotficationSuccses({required this.notficationList});
}

final class NotficationFail extends NotficationState {
  String errorMassage;
  NotficationFail({required this.errorMassage});
}
