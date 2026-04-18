import 'package:ecommerce_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/resend_otp_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
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

  // Supabase
  serviceLocator.registerLazySingleton(() => Supabase.instance.client);

  // ── Features ──────────────────────────────────────────────────────────────
  _initOnboardingDependencies();
  _initAuthDependencies();
}

void _initOnboardingDependencies() {
  serviceLocator.registerFactory(() => OnboardingCubit());
}

void _initAuthDependencies() {
  // Data Source
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Usecases
  serviceLocator.registerLazySingleton(() => SignUpUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => LoginUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => VerifyOtpUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ResendOtpUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ResetPasswordUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SendPasswordResetEmailUseCase(serviceLocator()));

  // Cubit
  serviceLocator.registerFactory(
    () => AuthCubit(
      signUpUseCase: serviceLocator(),
      loginUseCase: serviceLocator(),
      verifyOtpUseCase: serviceLocator(),
      resendOtpUseCase: serviceLocator(),
      sendResetEmailUseCase: serviceLocator(),
      resetPasswordUseCase: serviceLocator(),
    ),
  );
}

