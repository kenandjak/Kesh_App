import '../../domain/exceptions/domain_exception.dart';
import '../../domain/repositories/carteira_repository.dart';

class RealizarTransferencia {
  final ICarteiraRepository _repository;

  RealizarTransferencia(this._repository);

  Future<void> executar({
    required String idRemetente,
    required String idDestinatario,
    required double valor,
  }) async {
    if (idRemetente == idDestinatario) {
      throw TransferenciaInvalidaException(
        'Remetente e destinatário não podem ser o mesmo usuário.',
      );
    }

    final remetente = await _repository.obterPorId(idRemetente);
    final destinatario = await _repository.obterPorId(idDestinatario);

    if (remetente == null || destinatario == null) {
      throw TransferenciaInvalidaException('Usuário(s) não encontrado(s).');
    }

    remetente.debitar(valor);
    destinatario.adicionarSaldo(valor);

    await _repository.transferirSaldo(remetente, destinatario, valor);
  }
}
