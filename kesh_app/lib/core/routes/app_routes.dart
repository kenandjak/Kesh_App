import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/pages/auth_page.dart';
import '../../presentation/pages/home_page.dart';

final goRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: GetIt.I<AuthController>(),
  redirect: (context, state) {
    final auth = GetIt.I<AuthController>();
    final isLoggedIn = auth.session != null;
    final isOnLogin = state.matchedLocation == '/login';

    if (!isLoggedIn && !isOnLogin) return '/login';
    if (isLoggedIn && isOnLogin) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const AuthPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
  ],
);
