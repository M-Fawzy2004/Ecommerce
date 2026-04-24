import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthUser>> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    return _handleAuthOperation(() => remoteDataSource.signUpWithEmailPassword(
          fullName: fullName,
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, AuthUser>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _handleAuthOperation(() => remoteDataSource.loginWithEmailPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, Unit>> verifyOTP({
    required String email,
    required String token,
    bool isRecovery = false,
  }) async {
    return _handleUnitOperation(() => remoteDataSource.verifyOTP(
          email: email,
          token: token,
          isRecovery: isRecovery,
        ));
  }

  @override
  Future<Either<Failure, Unit>> resendOtp(String email) async {
    return _handleUnitOperation(() => remoteDataSource.resendOtp(email: email));
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    return _handleUnitOperation(
        () => remoteDataSource.sendPasswordResetEmail(email: email));
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String newPassword,
  }) async {
    return _handleUnitOperation(
        () => remoteDataSource.resetPassword(newPassword: newPassword));
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    // Logic for Google Sign In would go here (requires native integration)
    return left(const ServerFailure('Google Sign-In logic not yet implemented.'));
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithApple() async {
    // Logic for Apple Sign In would go here (requires native integration)
    return left(const ServerFailure('Apple Sign-In logic not yet implemented.'));
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return _handleUnitOperation(() => remoteDataSource.logout());
  }

  @override
  Future<Option<AuthUser>> get currentUser async {
    final session = remoteDataSource.currentUserSession;
    if (session == null) return none();
    return some(UserModel.fromMap(session.user.toJson()));
  }

  // ── Helper Methods for Error Handling ─────────────────────────────────────

  Future<Either<Failure, T>> _handleAuthOperation<T>(
      Future<T> Function() operation) async {
    try {
      final result = await operation();
      return right(result);
    } on NetworkException catch (e) {
      return left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> _handleUnitOperation(
      Future<void> Function() operation) async {
    try {
      await operation();
      return right(unit);
    } on NetworkException catch (e) {
      return left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}
