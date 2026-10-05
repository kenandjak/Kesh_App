// lib/core/routes/app_routes.dart
import 'package:go_router/go_router.dart';

import '../../presentation/pages/auth_page.dart';

final goRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const AuthPage()),
  ],
);
