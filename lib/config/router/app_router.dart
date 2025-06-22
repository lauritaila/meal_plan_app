
import 'package:go_router/go_router.dart';
import 'package:meal_plan_app/features/features.dart';

final appRouter = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const InitScreen()),
]);