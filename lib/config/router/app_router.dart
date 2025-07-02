import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // You need Riverpod to listen
import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';
import 'package:meal_plan_app/features/auth/auth.dart';

import '../../features/shared/shared.dart';

final appRouterProvider = Provider((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/init',
    routes: [
      GoRoute(path: '/init', builder: (context, state) => const InitScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
      // GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
    redirect: (context, state) {
      // final isGoingToLogin = state.fullPath == '/login';
      final isGoingToInit = state.fullPath == '/init';
      // final isGoingToRegister = state.fullPath == '/signup';


      // 1. If the state is loading or initial
      if (authState is InitialAuthState || authState is LoadingAuthState) { 
        return isGoingToInit ? null : '/init';
      }

      // 2. If the user is NOT authenticated or there is an authentication error
      // if (authState is UnauthenticatedAuthState || authState is ErrorAuthState) { 
      //   return (isGoingToLogin || isGoingToRegister) ? null : '/init';
      // }

      // 3. If the user IS authenticated
      // if (authState is AuthenticatedAuthState) { 
        // return (isGoingToLogin || isGoingToInit) ? '/home' : null;
      // }

      // 4. For the message state (temporary)
      // if (authState is MessageAuthState) { 
        // We do not redirect based on a message, let the normal flow continue
      //   return null;
      // }

      return null;
    },
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});