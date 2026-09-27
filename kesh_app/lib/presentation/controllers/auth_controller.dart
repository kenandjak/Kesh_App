import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_strategy.dart';

final class AuthController extends ChangeNotifier {
  AuthStrategy? _activeStrategy;
  AuthSession? session;
  bool loading = false;

  Future<void> loginWith(AuthStrategy strategy) async {
    loading = true;
    notifyListeners();
    try {
      _activeStrategy = strategy;
      session = await strategy.login();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _activeStrategy?.logout();
    _activeStrategy = null;
    session = null;
    notifyListeners();
  }
}
