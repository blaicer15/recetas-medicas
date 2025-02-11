part of 'auth_cubit.dart';

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthRecoveryState extends AuthState {
  const AuthRecoveryState();
}

abstract class AuthState {
  const AuthState();
}

class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);
}
