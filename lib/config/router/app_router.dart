import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meal_plan_app/features/auth/auth.dart';
import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';
import 'package:meal_plan_app/features/shared/shared.dart';

class GoRouterNotifier extends ChangeNotifier {
  final Ref _ref;
  
  GoRouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authProvider,
      (_, _) => notifyListeners(),
    );
  }
}

final goRouterNotifierProvider = Provider((ref) {
  return GoRouterNotifier(ref);
});

final appRouterProvider = Provider<GoRouter>((ref) {
  
  final goRouterNotifier = ref.watch(goRouterNotifierProvider);

  return GoRouter(
    refreshListenable: goRouterNotifier,
    initialLocation: '/init',
    
    routes: [
      GoRoute(path: '/init', builder: (context, state) => const InitScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
      GoRoute(path: '/preferences-wizard', builder: (context, state) => const PreferenceWizardScreen()),
      GoRoute(path: '/verify-otp', builder: (context, state) => const OtpVerificationScreen()),
      GoRoute(path: '/home', builder: (context, state) => const Scaffold(body: Center(child: Text('Home Screen')))),
    ],
    
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final currentLocation = state.matchedLocation;
      
      final publicRoutes = ['/login', '/signup', '/init'];
      
      if (authState is LoadingAuthState || authState is InitialAuthState) {
        return null;
      }

      if (authState is AwaitingOtpInputState) {
        return currentLocation == '/verify-otp' ? null : '/verify-otp';
      }

      if (authState is AuthenticatedAuthState) {
        final onboardingComplete = authState.user.onboardingComplete;

        if (!onboardingComplete) {
          return currentLocation == '/preferences-wizard' ? null : '/preferences-wizard';
        }
        
        if (publicRoutes.contains(currentLocation) || currentLocation == '/preferences-wizard' || currentLocation == '/verify-otp') {
          return '/home';
        }
      }

      if (authState is! AuthenticatedAuthState) {
        if (currentLocation == '/verify-otp') {
          return '/login';
        }

        if (!publicRoutes.contains(currentLocation)) {
          return '/login';
        }
      }

      return null;
    },
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});
