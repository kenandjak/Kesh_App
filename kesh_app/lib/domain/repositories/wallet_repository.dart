import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<Wallet?> getById(String id);
  // Transferir Saldo
  Future<void> transferBalance(Wallet sender, Wallet receiver, double amount);
}
