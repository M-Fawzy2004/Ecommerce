import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase implements UseCase<Unit, String> {
  final AuthRepository repository;

  SendPasswordResetEmailUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String email) async {
    return await repository.sendPasswordResetEmail(email: email);
  }
}
