import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // ── Core / Network ────────────────────────────────────────────────────────
  serviceLocator.registerLazySingleton(() => InternetConnection());
  
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => ApiClient().dio);

  // ── Features ──────────────────────────────────────────────────────────────
  // We will register feature dependencies here as we build them.
  _initAuthDependencies();
  _initProductsDependencies();
}

void _initAuthDependencies() {
  // Example for Auth
  // serviceLocator.registerFactory(() => AuthCubit(loginUseCase: serviceLocator()));
}

void _initProductsDependencies() {
  // Example for Products
  // serviceLocator.registerFactory(() => ProductsCubit(getProductsUseCase: serviceLocator()));
}
