
import 'package:go_router/go_router.dart';
import 'package:meal_plan_app/features/features.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
  GoRoute(path: '/', builder: (context, state) => const InitScreen()),
  GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
]);