import '../../domain/entities/user.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'fake_auth_clients.dart';

class FakeUserRepository implements UserRepository {
  @override
  Future<User?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return mockUsers.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getByEmail(String email) async => null;
  @override
  Future<void> saveUserAndWallet(User user, Wallet wallet) async {}
  @override
  Future<bool> verifyCpf(String cpf) async => false;
  @override
  Future<bool> verifyEmail(String email) async => false;
}

class FakeWalletRepository implements WalletRepository {
  @override
  Future<Wallet?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return mockWallets.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> transferBalance(
    Wallet sender,
    Wallet receiver,
    double amount,
  ) async {}
}
