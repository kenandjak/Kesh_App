import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../api/api_client.dart';

class ApiTransactionRepository implements TransactionRepository {
  final ApiClient api;

  ApiTransactionRepository(this.api);

  @override
  Future<List<Transaction>> getByWalletId(String walletId) async {
    final data = await api.get('/transactions/wallet/$walletId');

    final List<dynamic> items = data['transactions'];

    return items.map((item) {
      return Transaction(
        id: item['id'].toString(),
        dateTime: DateTime.parse(item['dateTime'].toString()),
        type: TransactionType.values.byName(item['type']),
        amount: double.parse(item['amount'].toString()),
        senderId: item['senderId']?.toString(),
        receiverId: item['receiverId'].toString(),
        status: TransactionStatus.values.byName(item['status'] ?? 'completed'),
      );
    }).toList();
  }
}
