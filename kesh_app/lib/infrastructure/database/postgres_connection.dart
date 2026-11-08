import 'package:postgres/postgres.dart';

class PostgresConnection {
  late Connection _connection;
  bool _isInitialized = false;

  Future<Connection> get connection async {
    if (!_isInitialized || !_connection.isOpen) {
      _connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'kesh_db',
          username: 'kesh_user',
          password: 'kesh_password',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      _isInitialized = true;
    }
    return _connection;
  }
}
