import 'package:go_router/go_router.dart';
import 'package:recetas_medicas/view/home.dart';
import 'package:recetas_medicas/view/login.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => const LoginView()),
  GoRoute(path: '/home', builder: (context, state) => const HomeView())
]);
