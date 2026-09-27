import '../../domain/exceptions/domain_exception.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../../domain/services/hash_service.dart';
import '../../domain/services/token_service.dart';

class LoginUsuario {
  final IUsuarioRepository _usuarioRepository;
  final IHashService _hashService;
  final ITokenService _tokenService;

  LoginUsuario(this._usuarioRepository, this._hashService, this._tokenService);

  Future<String> executar({
    required String email,
    required String senhaPlana,
  }) async {
    final usuario = await _usuarioRepository.obterPorEmail(email);

    if (usuario == null) {
      throw CredenciaisInvalidasException();
    }

    final senhaValida = _hashService.verificarSenha(
      senhaPlana,
      usuario.senhaHash,
    );

    if (!senhaValida) {
      throw CredenciaisInvalidasException();
    }

    if (usuario.isBloqueado) {
      throw UsuarioBloqueadoException();
    }

    return _tokenService.gerarToken(usuario);
  }
}
