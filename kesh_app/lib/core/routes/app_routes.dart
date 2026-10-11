import 'package:go_router/go_router.dart';

import '../../presentation/pages/auth_page.dart';
import '../../presentation/pages/home_page.dart';

final goRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const AuthPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
  ],
);
