import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';

import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, String>> call(String email, String password) {
    return repository.login(email, password);
  }
}
