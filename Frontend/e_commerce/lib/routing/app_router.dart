import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:e_commerce/providers/route_provider.dart';
import 'package:e_commerce/presentation/views/logIn_screen.dart';
import 'package:e_commerce/presentation/views/register_screen.dart';

import 'package:e_commerce/presentation/views/password_change_screen.dart';
import 'package:e_commerce/presentation/views/password_code_screen.dart';
import 'package:e_commerce/presentation/views/password_reset_screen.dart';
import 'package:e_commerce/presentation/views/verification_screen.dart';

import 'package:e_commerce/presentation/views/loading_screen.dart';
import 'package:e_commerce/presentation/views/home_screen.dart';

// configures Gorouter to handle routing based on the current route state managed by the routenotifier class
final goRouterProvider = Provider<GoRouter>((ref) {
  final route = ref.watch(routeNotifierProvider);

  return GoRouter(
    initialLocation: '/logIn',
    routes: [
      GoRoute(
        path: '/change-password',
        builder: (context, state) => PasswordChangeScreen(),
      ),
      GoRoute(
        path: '/password-reset',
        builder: (context, state) => PasswordResetScreen(),
      ),
      GoRoute(
        path: '/password-code',
        builder: (context, state) => PasswordCodeScreen(),
      ),
      GoRoute(
        path: '/logIn',
        builder: (context, state) => logInScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) => VerificationScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => LoadingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
    ],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      switch (route) {
        case AppRoute.passwordChange:
          return '/change-password';
        case AppRoute.verification:
          return '/verify';
        case AppRoute.passwordcode:
          return '/password-code';
        case AppRoute.passwordReset:
          return '/password-reset';
        case AppRoute.register:
          return '/register';
        case AppRoute.logIn:
          return '/logIn';
        case AppRoute.home:
          return '/home';
        case AppRoute.loading:
          return '/loading';
        default:
          return '/logIn';
      }
    },
  );
});
