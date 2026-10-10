import '../entities/user.dart';

abstract class TokenService {
  String generateToken(User user);
}
