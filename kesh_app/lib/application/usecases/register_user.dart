import '../../domain/entities/user.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/services/hash_service.dart';

import 'package:uuid/uuid.dart';

class RegisterUser {
  final UserRepository _userRepository;
  final HashService _hashService;
  final Uuid _uuid;

  RegisterUser(this._userRepository, this._hashService, this._uuid);

  Future<void> execute({
    required String fullName,
    required String cpf,
    required String email,
    required String phone,
    required String plainPassword,
  }) async {
    if (plainPassword.length < 6) {
      throw WeakPasswordException();
    }

    final emailExists = await _userRepository.verifyEmail(email);
    if (emailExists) throw EmailAlreadyRegisteredException();

    final cpfExists = await _userRepository.verifyCpf(cpf);
    if (cpfExists) throw CpfAlreadyRegisteredException();

    final passwordHash = _hashService.generateHash(plainPassword);

    final userId = 'USR-${_uuid.v4()}';
    final walletId = 'CRT-${_uuid.v4()}';

    final wallet = Wallet(id: walletId, initialBalance: 0.0);

    final user = User(
      id: userId,
      fullName: fullName,
      cpf: cpf,
      email: email,
      phone: phone,
      passwordHash: passwordHash,
      walletId: walletId,
    );

    await _userRepository.saveUserAndWallet(user, wallet);
  }
}
