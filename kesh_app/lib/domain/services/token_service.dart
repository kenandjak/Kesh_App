import '../entities/usuario.dart';

abstract class ITokenService {
  String gerarToken(Usuario usuario);
}
