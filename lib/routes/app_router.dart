import 'package:bloc_cubit/screen/home_screen.dart';
import 'package:bloc_cubit/screen/login_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          final username = state.extra as String? ?? '';
          return HomeScreen(username: username);
        },
      ),
    ],
  );
}
