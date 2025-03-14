import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, User>> call() {
    return repository.getProfile();
  }
}
