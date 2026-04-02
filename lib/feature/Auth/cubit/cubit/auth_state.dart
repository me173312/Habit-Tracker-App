part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthRegisterSucsses extends AuthState {}

final class AuthFaileRegister extends AuthState {
  String errorMassage;
  AuthFaileRegister({required this.errorMassage});
}

final class AuthLogInSucsses extends AuthState {}

final class AuthFaileLogin extends AuthState {
  String errorMassage;
  AuthFaileLogin({required this.errorMassage});
}

final class AuthForgetPasswordLoad extends AuthState {}

final class AuthForgetPasswordSucsses extends AuthState {}

final class AuthForgetPasswordFail extends AuthState {
  String errorMassage;
  AuthForgetPasswordFail({required this.errorMassage});
}

final class UpdateUserDataLooding extends AuthState {}

final class UpdateUserDataSuccsess extends AuthState {}

final class UpdateUserDataFail extends AuthState {
  String errorMessage;
  UpdateUserDataFail({required this.errorMessage});
}

final class UserVerificationLoad extends AuthState {}

final class UserVerificatiSuccses extends AuthState {}
