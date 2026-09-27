import '../../domain/repositories/token_manager.dart';

abstract interface class SecureStorageClient {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

final class SecureTokenManager implements TokenManager {
  SecureTokenManager(this.storage);
  final SecureStorageClient storage;
  static const key = 'access_token';

  @override
  Future<void> save(String token) => storage.write(key, token);

  @override
  Future<String?> read() => storage.read(key);

  @override
  Future<void> clear() => storage.delete(key);
}
