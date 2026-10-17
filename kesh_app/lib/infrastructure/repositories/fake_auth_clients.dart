import '../../domain/exceptions/domain_exception.dart';
import '../../infrastructure/strategies/email_password_auth_strategy.dart';
import '../../infrastructure/strategies/google_sign_in_auth_strategy.dart';

class FakeAuthApiClient implements AuthApiClient {
  @override
  Future<({String accessToken, String userId})> login(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'mickey@disney.com' && password == '123456') {
      return (accessToken: 'fake-jwt-token-123', userId: 'USR-12345');
    }

    throw InvalidCredentialsException();
  }

  @override
  Future<void> logout(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

class FakeGoogleAuthClient implements GoogleAuthClient {
  @override
  Future<({String id})?> signIn() async {
    await Future.delayed(const Duration(seconds: 1));
    return (id: 'google-usr-999');
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
