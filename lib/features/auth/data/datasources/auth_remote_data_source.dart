import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> verifyOTP({
    required String email,
    required String token,
    bool isRecovery = false,
  });

  Future<void> resendOtp({required String email});

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> resetPassword({
    required String newPassword,
  });

  Future<void> logout();
}
