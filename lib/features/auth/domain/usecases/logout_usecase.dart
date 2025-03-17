import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';

import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
