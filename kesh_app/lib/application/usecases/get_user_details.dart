import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/exceptions/domain_exception.dart';

class UserDetailsOutput {
  final String id;
  final String fullName;
  final String cpf;
  final String email;
  final String phone;
  final String walletId;
  final double balance;
  final String? profilePicture;
  final DateTime? createdAt;

  UserDetailsOutput({
    required this.id,
    required this.fullName,
    required this.cpf,
    required this.email,
    required this.phone,
    required this.walletId,
    required this.balance,
    this.profilePicture,
    this.createdAt,
  });

  String get shortName => fullName.split(' ').first;

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));

    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }

    return fullName[0].toUpperCase();
  }
}

class GetUserDetails {
  final UserRepository _userRepository;
  final WalletRepository _walletRepository;

  GetUserDetails(this._userRepository, this._walletRepository);

  Future<UserDetailsOutput> execute(String userId) async {
    final user = await _userRepository.getById(userId);

    if (user == null) {
      throw UserNotFoundException();
    }

    final wallet = await _walletRepository.getById(user.walletId);

    if (wallet == null) {
      throw WalletNotFoundException();
    }

    return UserDetailsOutput(
      id: user.id,
      fullName: user.fullName,
      cpf: user.cpf,
      email: user.email,
      phone: user.phone,
      walletId: wallet.id,
      balance: wallet.balance,
      profilePicture: user.profilePicture,
      createdAt: user.createdAt,
    );
  }
}
