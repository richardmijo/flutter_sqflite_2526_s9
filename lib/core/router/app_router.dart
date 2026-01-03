import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/home_page.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    refreshListenable: authProvider,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
    redirect: (context, state) {
      final isLoggingIn = state.uri.toString() == '/';
      final isLoggedIn = authProvider.status == AuthStatus.authenticated;

      // If not logged in and not on login page, redirect to login
      if (!isLoggedIn && !isLoggingIn) return '/';

      // If logged in and on login page, redirect to home
      if (isLoggedIn && isLoggingIn) return '/home';

      return null;
    },
  );
}
