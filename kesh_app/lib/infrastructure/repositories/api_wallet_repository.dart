import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../api/api_client.dart';

class ApiWalletRepository implements WalletRepository {
  final ApiClient api;

  ApiWalletRepository(this.api);

  @override
  Future<Wallet?> getById(String id) async {
    final data = await api.get('/wallets/$id');

    return Wallet(
      id: data['id'],
      initialBalance: double.parse(data['balance'].toString()),
    );
  }

  @override
  Future<void> transferBalance(
    Wallet sender,
    Wallet receiver,
    double amount,
  ) async {
    await api.post('/wallets/transfer', {
      'senderId': sender.id,
      'receiverId': receiver.id,
      'amount': amount.toStringAsFixed(2),
    });
  }
}
