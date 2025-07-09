import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_plan_app/features/auth/auth.dart';
import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';
import 'package:meal_plan_app/features/shared/shared.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/init',
    routes: [
      GoRoute(path: '/init', builder: (context, state) => const InitScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
      GoRoute(path: '/preferences-wizard', builder: (context, state) => const PreferenceWizardScreen()),
      GoRoute(path: '/verify-otp', builder: (context, state) => const OtpVerificationScreen()),
      // Asegúrate de tener una ruta de inicio
      GoRoute(path: '/home', builder: (context, state) => const Scaffold(body: Center(child: Text('Home Screen')))),
    ],
    redirect: (context, state) {
      final authRoutes = ['/login', '/signup', '/verify-otp', '/init'];
      final isGoingToAuthRoute = authRoutes.contains(state.matchedLocation);

      if (authState is LoadingAuthState) {
        return '/init';
      }

      if (authState is AwaitingOtpInputState) {
        return state.matchedLocation == '/verify-otp' ? null : '/verify-otp';
      }

      if (authState is AuthenticatedAuthState) {
        final onboardingComplete = authState.user.onboardingComplete;

        if (!onboardingComplete) {
          return state.matchedLocation == '/preferences-wizard' ? null : '/preferences-wizard';
        }

        if (isGoingToAuthRoute) {
          return '/home';
        }
      }
      if (authState is! AuthenticatedAuthState) {
        return isGoingToAuthRoute ? null : '/login';
      }
      return null;
    },
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});