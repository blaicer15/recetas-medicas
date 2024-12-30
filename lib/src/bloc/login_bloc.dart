library bloque_libreria;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:recetas_medicas/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final supabase = Supabase.instance.client;

  LoginBloc() : super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.username]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        print(state.username.value);
        print(state.password.value);
        await supabase.auth.signUp(
          email: state.username.value,
          password: state.password.value,
        );
        // await _userRepository.logIn(
        //   username: state.username.value,
        //   password: state.password.value,
        // );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (_) {
        print(_);
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([state.password, username]),
      ),
    );
  }
}
