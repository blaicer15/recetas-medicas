import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final supabase = Supabase.instance.client;

  AuthCubit() : super(AuthState(isLogged: false));

  setLoggedSignal(bool logged) {
    final user = supabase.auth.currentUser;
    if (user != null) {
      emit(state.copyWith(isLogged: true));
    }
  }
}
