import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:recetas/src/cubit/auth/auth_cubit.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Logger();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        logger.d('Auth State: $state');

        if (state is AuthSuccess) {
          context.go('/home');
        } else if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
