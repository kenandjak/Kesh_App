import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

// --- Imports: Casos de Uso (Módulo de Usuários) ---
import '../../application/usecases/cadastrar_usuario.dart';
import '../../application/usecases/login_usuario.dart';

// --- Imports: Autenticação SOLID (Módulo de Auth) ---
import '../../domain/repositories/auth_strategy.dart';
import '../../infrastructure/strategies/email_password_auth_strategy.dart';
import '../../infrastructure/strategies/google_sign_in_auth_strategy.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../domain/repositories/token_manager.dart';
import '../../infrastructure/security/secure_token_manager.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ---------------------------------------------------------------------------
  // PACOTES EXTERNOS
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => const Uuid());

  // ---------------------------------------------------------------------------
  // CLIENTES, SERVIÇOS E REPOSITÓRIOS (Infraestrutura)
  // ---------------------------------------------------------------------------
  // sl.registerLazySingleton<IUsuarioRepository>(() => UsuarioRepositorySqlite(db: sl()));
  // sl.registerLazySingleton<IHashService>(() => BcryptHashService());
  // sl.registerLazySingleton<ITokenService>(() => JwtTokenService());

  // Clientes da nova autenticação
  // sl.registerLazySingleton<AuthApiClient>(() => MeuAuthApiClient(dio: sl()));
  // sl.registerLazySingleton<GoogleAuthClient>(() => MeuGoogleAuthClient());
  sl.registerLazySingleton<TokenManager>(() => SecureTokenManager(sl()));

  // ---------------------------------------------------------------------------
  // CASOS DE USO (Aplicação)
  // ---------------------------------------------------------------------------
  sl.registerFactory(() => CadastrarUsuario(sl(), sl(), sl()));
  sl.registerFactory(() => LoginUsuario(sl(), sl(), sl()));

  // ---------------------------------------------------------------------------
  // CONTROLLERS (Apresentação)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => AuthController());

  // ---------------------------------------------------------------------------
  // ESTRATÉGIAS DE AUTENTICAÇÃO (Factories)
  // ---------------------------------------------------------------------------

  // Factory para Email e Senha (recebe os parâmetros da UI)
  sl.registerFactoryParam<AuthStrategy, String, String>(
    (email, password) => EmailPasswordAuthStrategy(
      api: sl(),
      tokens: sl(),
      email: email,
      password: password,
    ),
    instanceName: 'emailStrategy',
  );

  // Factory para Google (não precisa de parâmetros da UI)
  sl.registerFactory<AuthStrategy>(
    () => GoogleSignInAuthStrategy(sl()),
    instanceName: 'googleStrategy',
  );
}
