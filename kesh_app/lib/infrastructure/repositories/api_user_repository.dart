import '../../domain/entities/user.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/user_repository.dart';
import '../api/api_client.dart';

class ApiUserRepository implements UserRepository {
  final ApiClient api;

  ApiUserRepository(this.api);

  @override
  Future<User?> getById(String id) async {
    final data = await api.get('/users/$id');

    return User(
      id: data['id'],
      fullName: data['full_name'],
      cpf: data['cpf'],
      email: data['email'],
      phone: data['phone'],
      passwordHash: '',
      walletId: data['wallet_id'],
      profilePicture: data['profile_picture'],
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString())
          : null,
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
