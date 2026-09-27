import 'package:sqflite/sqflite.dart';

import '../../domain/entities/carteira.dart';
import '../../domain/repositories/carteira_repository.dart';

class CarteiraRepositorySqlite implements ICarteiraRepository {
  final Database _db;

  CarteiraRepositorySqlite(this._db);

  @override
  Future<Carteira?> obterPorId(String id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'carteiras',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Carteira(
      id: maps.first['id'] as String,
      saldoInicial: (maps.first['saldo'] as num).toDouble(),
    );
  }

  @override
  Future<void> transferirSaldo(
    Carteira remetente,
    Carteira destinatario,
    double valor,
  ) async {
    await _db.transaction((txn) async {
      try {
        // Atualiza o saldo do remetente
        await txn.rawUpdate('UPDATE carteiras SET saldo = ? WHERE id = ?', [
          remetente.saldo,
          remetente.id,
        ]);

        // Atualiza o saldo do destinatário
        await txn.rawUpdate('UPDATE carteiras SET saldo = ? WHERE id = ?', [
          destinatario.saldo,
          destinatario.id,
        ]);

        // Regista o histórico da transação
        final String idUnico = 'TXN-${DateTime.now().millisecondsSinceEpoch}';

        await txn.rawInsert(
          '''
          INSERT INTO transacoes (id, data_hora, tipo, valor, remetente_id, destinatario_id, status) 
          VALUES (?, ?, ?, ?, ?, ?, ?)
          ''',
          [
            idUnico,
            DateTime.now().toIso8601String(),
            'transferencia',
            valor,
            remetente.id,
            destinatario.id,
            'concluido',
          ],
        );
      } catch (e) {
        throw Exception('Erro ao processar transferência atómica: $e');
      }
    });
  }
}
