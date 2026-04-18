import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<Unit, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(VerifyOtpParams params) async {
    return await repository.verifyOTP(
      email: params.email,
      token: params.token,
      isRecovery: params.isRecovery,
    );
  }
}

class VerifyOtpParams {
  final String email;
  final String token;
  final bool isRecovery;

  VerifyOtpParams({
    required this.email,
    required this.token,
    this.isRecovery = false,
  });
}
