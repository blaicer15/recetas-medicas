import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:recetas/src/model/user/password.dart';
import 'package:recetas/src/model/user/username.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  static var logger = Logger();

  final supabase = Supabase.instance.client;

  LoginCubit()
      : super(const LoginState(
            status: FormzSubmissionStatus.initial,
            username: Username.dirty(),
            password: Password.dirty(),
            isValid: false));

  changePassword(String value) {
    final password = Password.dirty(value);

    emit(state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.username])));
  }

  changeUsername(String value) {
    final username = Username.dirty(value);

    emit(state.copyWith(
        username: username,
        isValid: Formz.validate([state.password, username])));
  }

  Future<void> onSubmitted() async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await supabase.auth.signUp(
            emailRedirectTo:
                kIsWeb ? null : "io.supabase.recetas://login-callback",
            email: state.username.value,
            password: state.password.value);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        logger.e(e);
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
