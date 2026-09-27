import '../entities/usuario.dart';
import '../entities/carteira.dart';

abstract class IUsuarioRepository {
  Future<bool> verificarEmailExistente(String email);
  Future<bool> verificarCpfExistente(String cpf);
  Future<void> salvarUsuarioECarteira(Usuario usuario, Carteira carteira);
  Future<Usuario?> obterPorEmail(String email);
}
