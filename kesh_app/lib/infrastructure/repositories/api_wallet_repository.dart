import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../api/api_client.dart';
import '../api/api_exception.dart';

class ApiWalletRepository implements WalletRepository {
  final ApiClient api;

  ApiWalletRepository(this.api);

  @override
  Future<Wallet?> getById(String id) async {
    try {
      final data = await api.get('/wallets/$id');

      return Wallet(
        id: data['id'].toString(),
        initialBalance: double.parse(data['balance'].toString()),
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }

      rethrow;
    }
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
      'amount': amount,
    });
  }
}
