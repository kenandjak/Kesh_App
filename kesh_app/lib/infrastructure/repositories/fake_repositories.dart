import '../../domain/entities/user.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/wallet_repository.dart';

class FakeUserRepository implements UserRepository {
  @override
  Future<User?> getById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: id,
      fullName: 'Mickey Mouse',
      cpf: '12345678909',
      email: 'mickey@disney.com',
      phone: '11999999999',
      passwordHash: 'hash',
      walletId: 'KSH-039284',
    );
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
    return Wallet(id: id, initialBalance: 2840.65);
  }

  @override
  Future<void> transferBalance(
    Wallet sender,
    Wallet receiver,
    double amount,
  ) async {}
}
