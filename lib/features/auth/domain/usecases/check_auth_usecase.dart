import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase {
  final AuthRepository repository;

  CheckAuthUseCase(this.repository);

  Future<Either<Failure, User>> call() {
    return repository.checkAuth();
  }
}
