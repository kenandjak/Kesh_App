// lib/application/usecases/cadastrar_usuario.dart
import '../../domain/entities/usuario.dart';
import '../../domain/entities/carteira.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../../domain/services/hash_service.dart';

import 'package:uuid/uuid.dart';

class CadastrarUsuario {
  final IUsuarioRepository _usuarioRepository;
  final IHashService _hashService;
  final Uuid _uuid;

  CadastrarUsuario(this._usuarioRepository, this._hashService, this._uuid);

  Future<void> executar({
    required String nomeCompleto,
    required String cpf,
    required String email,
    required String telefone,
    required String senhaPlana,
  }) async {
    if (senhaPlana.length < 6) {
      throw SenhaFracaException();
    }

    final emailExiste = await _usuarioRepository.verificarEmailExistente(email);
    if (emailExiste) throw EmailJaCadastradoException();

    final cpfExiste = await _usuarioRepository.verificarCpfExistente(cpf);

    if (cpfExiste) throw CpfJaCadastradoException();

    final senhaHash = _hashService.gerarHash(senhaPlana);
    final usuarioId = 'USR-${_uuid.v4()}';
    final carteiraId = 'CRT-${_uuid.v4()}';
    final carteira = Carteira(id: carteiraId, saldoInicial: 0.0);

    final usuario = Usuario(
      id: usuarioId,
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      email: email,
      telefone: telefone,
      senhaHash: senhaHash,
      carteiraId: carteiraId,
    );

    await _usuarioRepository.salvarUsuarioECarteira(usuario, carteira);
  }
}
