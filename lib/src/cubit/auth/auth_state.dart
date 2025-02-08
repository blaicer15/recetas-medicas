part of 'auth_cubit.dart';

final class AuthState {
  final bool isLogged;

  AuthState({required this.isLogged});

  AuthState copyWith({bool? isLogged}) {
    return AuthState(isLogged: isLogged ?? false);
  }
}
