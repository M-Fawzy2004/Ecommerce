import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<AuthUser, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(SignUpParams params) async {
    return await repository.signUpWithEmailPassword(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams {
  final String fullName;
  final String email;
  final String password;

  SignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
  });
}
