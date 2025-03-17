import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';

import '../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<Failure, String>> call(String refreshToken) {
    return repository.refreshToken(refreshToken);
  }
}
