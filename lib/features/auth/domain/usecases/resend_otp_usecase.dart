import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ResendOtpUseCase implements UseCase<Unit, String> {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String email) async {
    return await repository.resendOtp(email);
  }
}
