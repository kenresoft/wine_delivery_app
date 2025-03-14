import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, Tuple2<User, AuthTokens>>> call(String email, String otp) {
    return repository.verifyOtp(email, otp);
  }
}
