import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';

import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, String>> call(String username, String email, String password) {
    return repository.register(username, email, password);
  }
}
