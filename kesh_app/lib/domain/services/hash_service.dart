abstract class HashService {
  String generateHash(String plainPassword);
  bool verifyPassword(String plainPassword, String hash);
}
