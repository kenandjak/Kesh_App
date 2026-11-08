import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_strategy.dart';

final class AuthController extends ChangeNotifier {
  AuthStrategy? _activeStrategy;
  AuthSession? session;
  bool loading = false;
  String? errorMessage;

  Future<void> loginWith(AuthStrategy strategy) async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _activeStrategy = strategy;
      session = await strategy.login();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
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
