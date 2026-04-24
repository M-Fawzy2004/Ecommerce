import 'package:ecommerce_app/core/network/api_client.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce_app/features/home/data/datasources/recently_viewed_local_data_source.dart';
import 'package:ecommerce_app/features/home/data/repositories/recently_viewed_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:ecommerce_app/core/cubits/network_cubit.dart';
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
import '../network/network_info.dart';
import '../../features/categories/data/datasources/categories_remote_data_source.dart';
import '../../features/categories/data/datasources/categories_remote_data_source_impl.dart';
import '../../features/categories/data/repositories/categories_repository_impl.dart';
import '../../features/categories/domain/repositories/categories_repository.dart';
import '../../features/categories/domain/usecases/get_products_by_category_usecase.dart';
import '../../features/categories/presentation/cubit/category_details_cubit.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../features/product_details/data/datasources/product_details_remote_data_source.dart';
import '../../features/product_details/data/repositories/product_details_repository_impl.dart';
import '../../features/product_details/domain/repositories/product_details_repository.dart';
import '../../features/product_details/domain/usecases/get_product_details_usecase.dart';
import '../../features/product_details/presentation/cubit/product_details_cubit.dart';
import '../../features/product_details/data/datasources/reviews_remote_data_source.dart';
import '../../features/product_details/data/repositories/reviews_repository_impl.dart';
import '../../features/product_details/domain/repositories/reviews_repository.dart';
import '../../features/product_details/domain/usecases/reviews_usecases.dart';
import '../../features/product_details/presentation/cubit/reviews_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/presentation/cubit/recently_viewed_cubit.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/presentation/cubit/hot_sales_cubit.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../features/search/data/datasources/search_remote_data_source.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // ── Core / Network ────────────────────────────────────────────────────────
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);

  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => const NetworkInfoImpl(),
  );

  serviceLocator.registerLazySingleton(
    () => NetworkCubit(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => ApiClient().dio);

  // Supabase
  serviceLocator.registerLazySingleton(() => Supabase.instance.client);

  // ── Features ──────────────────────────────────────────────────────────────
  _initOnboardingDependencies();
  _initAuthDependencies();
  _initCategoriesDependencies();
  _initProductDetailsDependencies();
  _initReviewsDependencies();
  _initRecentlyViewedDependencies();
  _initHomeDependencies();
  _initFavoritesDependencies();
  _initSearchDependencies();
  _initCartDependencies();
}

void _initFavoritesDependencies() {
  serviceLocator.registerLazySingleton(() => FavoritesCubit());
}

// ... existing code ...

void _initProductDetailsDependencies() {
  // Data Source
  serviceLocator.registerLazySingleton<ProductDetailsRemoteDataSource>(
    () => ProductDetailsRemoteDataSourceImpl(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepositoryImpl(
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // UseCase
  serviceLocator.registerLazySingleton(
    () => GetProductDetailsUseCase(serviceLocator()),
  );

  // Cubit
  serviceLocator.registerFactory(
    () => ProductDetailsCubit(
      getProductDetailsUseCase: serviceLocator(),
    ),
  );
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
  serviceLocator
      .registerLazySingleton(() => VerifyOtpUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ResendOtpUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ResetPasswordUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => SendPasswordResetEmailUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => LogoutUseCase(serviceLocator()));

  // Cubit
  serviceLocator.registerFactory(
    () => AuthCubit(
      signUpUseCase: serviceLocator(),
      loginUseCase: serviceLocator(),
      verifyOtpUseCase: serviceLocator(),
      resendOtpUseCase: serviceLocator(),
      sendResetEmailUseCase: serviceLocator(),
      resetPasswordUseCase: serviceLocator(),
      logoutUseCase: serviceLocator(),
    ),
  );
}

void _initCategoriesDependencies() {
  // Data Source
  serviceLocator.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Usecases
  serviceLocator
      .registerLazySingleton(() => GetCategoriesUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetProductsByCategoryUseCase(serviceLocator()));

  // Cubit
  serviceLocator.registerFactory(
    () => CategoriesCubit(
      getCategoriesUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => CategoryDetailsCubit(
      getProductsByCategoryUseCase: serviceLocator(),
    ),
  );
}

void _initReviewsDependencies() {
  serviceLocator.registerLazySingleton<ReviewsRemoteDataSource>(
    () => ReviewsRemoteDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepositoryImpl(
      remote: serviceLocator(),
      network: serviceLocator(),
    ),
  );

  serviceLocator
      .registerLazySingleton(() => GetProductReviewsUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetRatingSummaryUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetMyReviewUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => AddReviewUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteReviewUseCase(serviceLocator()));

  serviceLocator.registerFactory(
    () => ReviewsCubit(
      getReviews: serviceLocator(),
      getSummary: serviceLocator(),
      getMyReview: serviceLocator(),
      addReview: serviceLocator(),
      deleteReview: serviceLocator(),
    ),
  );
}

void _initRecentlyViewedDependencies() {
  serviceLocator.registerLazySingleton<RecentlyViewedLocalDataSource>(
    () => RecentlyViewedLocalDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<RecentlyViewedRepository>(
    () => RecentlyViewedRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => RecentlyViewedCubit(serviceLocator()),
  );
}

void _initHomeDependencies() {
  // Data Source
  serviceLocator.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Cubit
  serviceLocator.registerFactory(
    () => HotSalesCubit(serviceLocator()),
  );
}

void _initSearchDependencies() {
  // Data Source
  serviceLocator.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  // Cubit
  serviceLocator.registerFactory(
    () => SearchCubit(serviceLocator()),
  );
}

void _initCartDependencies() {
  serviceLocator.registerLazySingleton(() => CartCubit());
}

