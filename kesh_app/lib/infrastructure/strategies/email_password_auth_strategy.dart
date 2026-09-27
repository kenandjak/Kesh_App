import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_strategy.dart';
import '../../domain/repositories/token_manager.dart';

abstract interface class AuthApiClient {
  Future<({String accessToken, String userId})> login(
    String email,
    String password,
  );
  Future<void> logout(String token);
}

final class EmailPasswordAuthStrategy implements AuthStrategy {
  EmailPasswordAuthStrategy({
    required this.api,
    required this.tokens,
    required this.email,
    required this.password,
  });

  final AuthApiClient api;
  final TokenManager tokens;
  final String email;
  final String password;

  @override
  Future<AuthSession> login() async {
    final result = await api.login(email, password);
    await tokens.save(result.accessToken);
    return AuthSession(userId: result.userId, provider: 'email');
  }

  @override
  Future<void> logout() async {
    final token = await tokens.read();
    if (token != null) await api.logout(token);
    await tokens.clear();
  }
}
