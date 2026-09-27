import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_strategy.dart';

abstract interface class GoogleAuthClient {
  Future<({String id})?> signIn();
  Future<void> signOut();
}

final class GoogleSignInAuthStrategy implements AuthStrategy {
  GoogleSignInAuthStrategy(this.google);
  final GoogleAuthClient google;

  @override
  Future<AuthSession> login() async {
    final account = await google.signIn();
    if (account == null) {
      throw Exception('Login com Google cancelado.');
    }
    return AuthSession(userId: account.id, provider: 'google');
  }

  @override
  Future<void> logout() async {
    await google.signOut();
  }
}
