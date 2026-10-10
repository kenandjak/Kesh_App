import '../../domain/exceptions/domain_exception.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/services/hash_service.dart';
import '../../domain/services/token_service.dart';

class LoginUser {
  final UserRepository _userRepository;
  final HashService _hashService;
  final TokenService _tokenService;

  LoginUser(this._userRepository, this._hashService, this._tokenService);

  Future<String> execute({
    required String email,
    required String plainPassword,
  }) async {
    final user = await _userRepository.getByEmail(email);

    if (user == null) {
      throw InvalidCredentialsException();
    }

    final isPasswordValid = _hashService.verifyPassword(
      plainPassword,
      user.passwordHash,
    );

    if (!isPasswordValid) {
      throw InvalidCredentialsException();
    }

    if (user.isBlocked) {
      throw UserBlockedException();
    }

    return _tokenService.generateToken(user);
  }
}
