import '../../domain/entities/user.dart';
import '../../domain/entities/wallet.dart';
import '../../infrastructure/strategies/email_password_auth_strategy.dart';
import '../../infrastructure/strategies/google_sign_in_auth_strategy.dart';

final mockUsers = [
  User(
    id: 'USR-001',
    fullName: 'Mickey Mouse Mosca',
    cpf: '111.111.111-11',
    email: 'mickey@disney.com',
    phone: '(11) 98765-4321',
    passwordHash: '123456',
    walletId: 'KSH-039284',
  ),
  User(
    id: 'USR-002',
    fullName: 'Frodo Bolseiro',
    cpf: '222.222.222-22',
    email: 'frodo@email.com',
    phone: '(11) 99999-2222',
    passwordHash: '123456',
    walletId: 'KSH-112233',
  ),
  User(
    id: 'USR-003',
    fullName: 'Ashley Banks',
    cpf: '333.333.333-33',
    email: 'ashley@belair.com',
    phone: '(11) 98888-3333',
    passwordHash: '111111',
    walletId: 'KSH-998877',
  ),
];

final mockWallets = [
  Wallet(id: 'KSH-039284', initialBalance: 2840.65),
  Wallet(id: 'KSH-112233', initialBalance: 150.00),
  Wallet(id: 'KSH-998877', initialBalance: 5900.00),
];

class FakeAuthApiClient implements AuthApiClient {
  @override
  Future<({String accessToken, String userId})> login(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = mockUsers.firstWhere(
        (u) => u.email == email && u.passwordHash == password,
      );
      return (accessToken: 'jwt-token-${user.id}', userId: user.id);
    } catch (e) {
      throw Exception('Credenciais inválidas');
    }
  }

  @override
  Future<void> logout(String token) async {}
}

class FakeGoogleAuthClient implements GoogleAuthClient {
  @override
  Future<({String id})?> signIn() async {
    await Future.delayed(const Duration(seconds: 1));
    return (id: 'USR-002');
  }

  @override
  Future<void> signOut() async {}
}
