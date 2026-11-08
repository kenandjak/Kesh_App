import 'package:postgres/postgres.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/user_repository.dart';
import '../database/postgres_connection.dart';

class PostgresUserRepository implements UserRepository {
  final PostgresConnection db;

  PostgresUserRepository(this.db);

  @override
  Future<User?> getById(String id) async {
    final conn = await db.connection;
    final result = await conn.execute(
      Sql.named('SELECT * FROM users WHERE id = @id'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final row = result[0].toColumnMap();
    return User(
      id: row['id'] as String,
      fullName: row['full_name'] as String,
      cpf: row['cpf'] as String,
      email: row['email'] as String,
      phone: row['phone'] as String,
      passwordHash: row['password_hash'] as String,
      walletId: row['wallet_id'] as String,
      profilePicture: row['profile_picture'] as String?,
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
