part of 'login_cubit.dart';

final class LoginState {
  final FormzSubmissionStatus status;

  final Username username;
  final Password password;
  final bool isValid;

  const LoginState(
      {required this.status,
      required this.username,
      required this.password,
      required this.isValid});

  LoginState copyWith(
      {FormzSubmissionStatus? status,
      Username? username,
      Password? password,
      bool? isValid}) {
    return LoginState(
        status: status ?? this.status,
        username: username ?? this.username,
        password: password ?? this.password,
        isValid: isValid ?? this.isValid);
  }
}
