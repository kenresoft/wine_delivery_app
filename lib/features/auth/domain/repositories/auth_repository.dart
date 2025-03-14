import 'package:dartz/dartz.dart';

import '../../core/failures/failures.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> register(String username, String email, String password);

  Future<Either<Failure, String>> login(String email, String password);

  Future<Either<Failure, Tuple2<User, AuthTokens>>> verifyOtp(String email, String otp);

  Future<Either<Failure, User>> getProfile();

  Future<Either<Failure, User>> checkAuth();

  Future<Either<Failure, String>> refreshToken(String refreshToken);

  Future<Either<Failure, void>> logout();
}
