import 'package:sqflite/sqflite.dart';

import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletRepositorySqlite implements WalletRepository {
  final Database _db;

  WalletRepositorySqlite(this._db);

  @override
  Future<Wallet?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'wallets',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Wallet(
      id: maps.first['id'] as String,
      initialBalance: (maps.first['balance'] as num).toDouble(),
    );
  }

  @override
  Future<void> transferBalance(
    Wallet sender,
    Wallet receiver,
    double amount,
  ) async {
    await _db.transaction((txn) async {
      try {
        // Atualiza o saldo do remetente
        await txn.rawUpdate('UPDATE wallets SET balance = ? WHERE id = ?', [
          sender.balance,
          sender.id,
        ]);

        // Atualiza o saldo do destinatário
        await txn.rawUpdate('UPDATE wallets SET balance = ? WHERE id = ?', [
          receiver.balance,
          receiver.id,
        ]);

        // Regista o histórico da transação
        final String idUnico = 'TXN-${DateTime.now().millisecondsSinceEpoch}';

        await txn.rawInsert(
          '''
          INSERT INTO transactions (id, data_hora, type, amount, sender_id, receiver_id, status) 
          VALUES (?, ?, ?, ?, ?, ?, ?)
          ''',
          [
            idUnico,
            DateTime.now().toIso8601String(),
            'transfer',
            amount,
            sender.id,
            receiver.id,
            'done',
          ],
        );
      } catch (e) {
        throw Exception('Erro ao processar transferência atômica: $e');
      }
    });
  }
}
