import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../application/usecases/register_user.dart';
import '../../application/usecases/login_user.dart';
import '../../application/usecases/get_user_details.dart';

import '../../domain/repositories/auth_strategy.dart';
import '../../domain/repositories/token_manager.dart';
import '../../infrastructure/security/secure_token_manager.dart';
import '../../infrastructure/repositories/fake_secure_storage_client.dart';

import '../../infrastructure/strategies/email_password_auth_strategy.dart';
import '../../infrastructure/strategies/google_sign_in_auth_strategy.dart';
//import '../../infrastructure/strategies/postgres_auth_api_client.dart';

import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/home_controller.dart';
import '../../presentation/controllers/profile_controller.dart';
import '../../presentation/controllers/statement_controller.dart';

import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/wallet_repository.dart';

//import '../../infrastructure/database/postgres_connection.dart';
//import '../../infrastructure/repositories/postgres_user_repository.dart';
//import '../../infrastructure/repositories/postgres_wallet_repository.dart';
import '../../infrastructure/repositories/fake_auth_clients.dart';
import '../../infrastructure/repositories/fake_repositories.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  sl.registerLazySingleton(() => const Uuid());
  //sl.registerLazySingleton(() => PostgresConnection());

  // sl.registerLazySingleton<UsuarioRepository>(() => UsuarioRepositorySqlite(db: sl()));

  sl.registerLazySingleton<AuthApiClient>(
    () => FakeAuthApiClient(),
  ); // <-- USANDO FAKE
  sl.registerLazySingleton<GoogleAuthClient>(() => FakeGoogleAuthClient());
  sl.registerLazySingleton<SecureStorageClient>(
    () => FakeSecureStorageClient(),
  );
  sl.registerLazySingleton<TokenManager>(() => SecureTokenManager(sl()));

  sl.registerLazySingleton<UserRepository>(
    () => FakeUserRepository(),
  ); // <-- USANDO FAKE
  sl.registerLazySingleton<WalletRepository>(
    () => FakeWalletRepository(),
  ); // <-- USANDO FAKE

  // sl.registerLazySingleton<HashService>(() => BcryptHashService());
  // sl.registerLazySingletonTokenService>(() => JwtTokenService());

  // CASOS DE USO
  sl.registerFactory(() => RegisterUser(sl(), sl(), sl()));
  sl.registerFactory(() => LoginUser(sl(), sl(), sl()));
  sl.registerFactory(() => GetUserDetails(sl(), sl()));

  // CONTROLLERS (Apresentação)
  sl.registerLazySingleton(() => AuthController());
  sl.registerLazySingleton(() => HomeController(sl()));
  sl.registerLazySingleton(() => ProfileController());
  sl.registerLazySingleton(() => StatementController());

  sl.registerFactoryParam<AuthStrategy, String, String>(
    (email, password) => EmailPasswordAuthStrategy(
      api: sl(),
      tokens: sl(),
      email: email,
      password: password,
    ),
    instanceName: 'emailStrategy',
  );

  sl.registerFactory<AuthStrategy>(
    () => GoogleSignInAuthStrategy(sl()),
    instanceName: 'googleStrategy',
  );
}
