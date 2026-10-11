import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

// --- Imports: Casos de Uso (Módulo de Usuários) ---
import '../../application/usecases/register_user.dart';
import '../../application/usecases/login_user.dart';
import '../../application/usecases/get_user_details.dart';

// --- Imports: Autenticação SOLID (Módulo de Auth) ---
import '../../domain/repositories/auth_strategy.dart';
import '../../infrastructure/strategies/email_password_auth_strategy.dart';
import '../../infrastructure/strategies/google_sign_in_auth_strategy.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/home_controller.dart';
import '../../domain/repositories/token_manager.dart';
import '../../infrastructure/security/secure_token_manager.dart';

// --- Imports: Repositórios
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/wallet_repository.dart';

// --- Imports: Infraestrutura Fake
import '../../infrastructure/repositories/fake_repositories.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ---------------------------------------------------------------------------
  // PACOTES EXTERNOS
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => const Uuid());

  // ---------------------------------------------------------------------------
  // CLIENTES, SERVIÇOS E REPOSITÓRIOS (Infraestrutura)
  // ---------------------------------------------------------------------------
  // sl.registerLazySingleton<UsuarioRepository>(() => UsuarioRepositorySqlite(db: sl()));
  sl.registerLazySingleton<UserRepository>(() => FakeUserRepository());
  sl.registerLazySingleton<WalletRepository>(() => FakeWalletRepository());
  // sl.registerLazySingleton<HashService>(() => BcryptHashService());
  // sl.registerLazySingletonITokenService>(() => JwtTokenService());

  // Clientes da nova autenticação
  // sl.registerLazySingleton<AuthApiClient>(() => MeuAuthApiClient(dio: sl()));
  // sl.registerLazySingleton<GoogleAuthClient>(() => MeuGoogleAuthClient());
  sl.registerLazySingleton<TokenManager>(() => SecureTokenManager(sl()));

  // ---------------------------------------------------------------------------
  // CASOS DE USO (Aplicação)
  // ---------------------------------------------------------------------------
  sl.registerFactory(() => RegisterUser(sl(), sl(), sl()));
  sl.registerFactory(() => LoginUser(sl(), sl(), sl()));
  sl.registerFactory(() => GetUserDetails(sl(), sl()));

  // ---------------------------------------------------------------------------
  // CONTROLLERS (Apresentação)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => AuthController());
  sl.registerLazySingleton(() => HomeController(sl()));

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
