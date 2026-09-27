abstract class IHashService {
  String gerarHash(String senhaPlana);
  bool verificarSenha(String senhaPlana, String hash);
}
