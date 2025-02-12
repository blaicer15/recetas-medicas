import 'package:go_router/go_router.dart';
import 'package:recetas/view/Splash.dart';
import 'package:recetas/view/add_person.dart';
import 'package:recetas/view/add_recipe.dart';
import 'package:recetas/view/home.dart';
import 'package:recetas/view/login.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => SplashView(),
  ),
  GoRoute(path: '/login', builder: (context, state) => const LoginView()),
  GoRoute(
      path: '/home',
      name: "home",
      builder: (context, state) => const HomeView()),
  GoRoute(
    path: '/addPerson',
    builder: (context, state) => const AddPerson(),
  ),
  GoRoute(
    path: '/addRecipe',
    builder: (context, state) => const AddRecipe(),
  ),
]);
