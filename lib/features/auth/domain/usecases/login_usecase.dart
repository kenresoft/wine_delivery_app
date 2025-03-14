import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, String>> call(String email, String password) {
    return repository.login(email, password);
  }
}
