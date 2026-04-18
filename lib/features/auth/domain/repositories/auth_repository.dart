import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> verifyOTP({
    required String email,
    required String token,
    bool isRecovery = false,
  });

  Future<Either<Failure, Unit>> resendOtp(String email);

  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, Unit>> resetPassword({
    required String newPassword,
  });

  Future<Either<Failure, AuthUser>> signInWithGoogle();
  
  Future<Either<Failure, AuthUser>> signInWithApple();

  Future<Either<Failure, Unit>> logout();
  
  Future<Option<AuthUser>> get currentUser;
}
