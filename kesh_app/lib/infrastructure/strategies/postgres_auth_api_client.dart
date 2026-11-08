import 'package:postgres/postgres.dart';

import '../../infrastructure/database/postgres_connection.dart';
import 'email_password_auth_strategy.dart';

class PostgresAuthApiClient implements AuthApiClient {
  final PostgresConnection db;

  PostgresAuthApiClient(this.db);

  @override
  Future<({String accessToken, String userId})> login(
    String email,
    String password,
  ) async {
    final conn = await db.connection;

    final result = await conn.execute(
      Sql.named(
        'SELECT id FROM users WHERE email = @email AND password_hash = @password',
      ),
      parameters: {'email': email, 'password': password},
    );

    if (result.isEmpty) {
      throw Exception('Credenciais inválidas');
    }

    final userId = result[0][0] as String;
    return (accessToken: 'jwt-token-$userId', userId: userId);
  }

  @override
  Future<void> logout(String token) async {}
}
