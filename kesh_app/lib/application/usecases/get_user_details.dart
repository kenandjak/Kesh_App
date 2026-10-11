import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/exceptions/domain_exception.dart';

class UserDetailsOutput {
  final String userName;
  final String walletId;
  final double balance;

  UserDetailsOutput({
    required this.userName,
    required this.walletId,
    required this.balance,
  });
}

class GetUserDetails {
  final UserRepository _userRepository;
  final WalletRepository _walletRepository;

  GetUserDetails(this._userRepository, this._walletRepository);

  Future<UserDetailsOutput> execute(String userId) async {
    final user = await _userRepository.getById(userId);
    if (user == null) throw UserNotFoundException();

    final wallet = await _walletRepository.getById(user.walletId);
    if (wallet == null) throw WalletNotFoundException();

    return UserDetailsOutput(
      userName: user.fullName.split(' ').first,
      walletId: wallet.id,
      balance: wallet.balance,
    );
  }
}
