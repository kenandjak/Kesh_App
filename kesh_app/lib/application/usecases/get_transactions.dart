import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository _repository;

  GetTransactions(this._repository);

  Future<List<Transaction>> execute(String walletId) async {
    if (walletId.isEmpty) {
      throw ArgumentError('Identificador da carteira inválido.');
    }

    return await _repository.getByWalletId(walletId);
  }
}
