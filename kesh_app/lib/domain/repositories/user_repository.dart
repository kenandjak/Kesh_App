import '../entities/user.dart';
import '../entities/wallet.dart';

abstract class UserRepository {
  Future<bool> verifyEmail(String email);
  Future<bool> verifyCpf(String cpf);
  Future<void> saveUserAndWallet(User user, Wallet wallet);
  Future<User?> getByEmail(String email);
}
