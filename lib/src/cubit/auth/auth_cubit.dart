import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final logger = Logger();
  final supabase = Supabase.instance.client;

  late StreamSubscription _authSubscription;

  AuthCubit() : super(const AuthInitial()) {
    _initializeAuthListener();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  void _initializeAuthListener() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      logger.d("Evento: $event, session: ${session?.accessToken}");

      switch (event) {
        case AuthChangeEvent.initialSession:
          if (session != null) {
            emit(AuthSuccess(session.user));
          } else {
            emit(const AuthInitial());
          }
          break;

        case AuthChangeEvent.signedIn:
          if (session != null) {
            emit(AuthSuccess(session.user));
          }
          break;

        case AuthChangeEvent.signedOut:
          emit(const AuthInitial());
          break;

        case AuthChangeEvent.passwordRecovery:
          emit(const AuthRecoveryState());
          break;

        case AuthChangeEvent.tokenRefreshed:
          if (session != null) {
            emit(AuthSuccess(session.user));
          }
          break;

        case AuthChangeEvent.userUpdated:
          if (session != null) {
            emit(AuthSuccess(session.user));
          }
          break;

        case AuthChangeEvent.userDeleted:
          emit(const AuthInitial());
          break;

        case AuthChangeEvent.mfaChallengeVerified:
          // Manejar verificación MFA si es necesario
          break;
      }
    });
  }
}
