import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../database/postgres_connection.dart';

import 'package:postgres/postgres.dart';

class PostgresWalletRepository implements WalletRepository {
  final PostgresConnection db;

  PostgresWalletRepository(this.db);

  @override
  Future<Wallet?> getById(String id) async {
    final conn = await db.connection;

    final result = await conn.execute(
      Sql.named('SELECT * FROM wallets WHERE id = @id'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final row = result[0].toColumnMap();

    return Wallet(
      id: row['id'] as String,
      initialBalance: double.parse(row['balance'].toString()),
    );
  }

  @override
  Future<void> transferBalance(
    Wallet sender,
    Wallet receiver,
    double amount,
  ) async {
    // Transaction (BEGIN/COMMIT)
  }
}
