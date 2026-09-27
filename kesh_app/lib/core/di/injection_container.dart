import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

//import '../../domain/repositories/usuario_repository.dart';
//import '../../domain/services/hash_service.dart';
//import '../../domain/services/token_service.dart';
import '../../application/usecases/cadastrar_usuario.dart';
import '../../application/usecases/login_usuario.dart';

// Importe as classes concretas (que você ainda vai criar/finalizar)
// import '../../infrastructure/repositories/usuario_repository_sqlite.dart';
// import '../../infrastructure/services/bcrypt_hash_service.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // Casos de Uso (Camada de Aplicação)
  // O sl() descobre automaticamente qual dependência injetar com base no tipo esperado pelo construtor.
  sl.registerFactory(() => CadastrarUsuario(sl(), sl(), sl()));
  sl.registerFactory(() => LoginUsuario(sl(), sl(), sl()));

  // Repositórios (Camada de Infraestrutura)
  // sl.registerLazySingleton<IUsuarioRepository>(() => UsuarioRepositorySqlite(db: sl()));

  // Serviços (Camada de Infraestrutura)
  // sl.registerLazySingleton<IHashService>(() => BcryptHashService());
  // sl.registerLazySingleton<ITokenService>(() => JwtTokenService());

  // Pacotes Externos
  sl.registerLazySingleton(() => const Uuid());
}
