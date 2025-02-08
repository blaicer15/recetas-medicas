import 'package:go_router/go_router.dart';
import 'package:recetas/view/Splash.dart';
import 'package:recetas/view/home.dart';
import 'package:recetas/view/login.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashView(),
  ),
  GoRoute(path: '/login', builder: (context, state) => const LoginView()),
  GoRoute(
      path: '/home',
      name: "home",
      builder: (context, state) => const HomeView())
]);
