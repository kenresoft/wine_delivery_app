import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/models/auth_tokens_model.dart';
import 'package:vintiora/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, String>> register(String username, String email, String password);

  Future<Either<Failure, String>> login(String email, String password);

  Future<Either<Failure, Map<String, dynamic>>> verifyOtp(String email, String otp);

  Future<Either<Failure, UserModel>> getProfile();

  Future<Either<Failure, UserModel>> checkAuth();

  Future<Either<Failure, String>> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final IApiService _apiService;

  AuthRemoteDataSourceImpl({required IApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failure, String>> register(String username, String email, String password) async {
    return await _apiService.request<String>(
      endpoint: ApiConstants.register,
      method: RequestMethod.post,
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
      parser: (data) {
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return data['message'] as String;
        }
        return 'Registration successful. Please check your email for verification.';
      },
      requiresAuth: false,
    );
  }

  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    return await _apiService.request<String>(
      endpoint: ApiConstants.login,
      method: RequestMethod.post,
      data: {
        'email': email,
        'password': password,
      },
      parser: (data) {
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return data['message'] as String;
        }
        return 'Verification code sent. Please check your email.';
      },
      requiresAuth: false,
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyOtp(String email, String otp) async {
    return await _apiService.request<Map<String, dynamic>>(
      endpoint: ApiConstants.verifyOtp,
      method: RequestMethod.post,
      data: {
        'email': email,
        'otp': otp,
      },
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          final userModel = UserModel.fromJson(data['user']);
          final tokensModel = AuthTokensModel(
            accessToken: data['accessToken'],
            refreshToken: data['refreshToken'],
          );
          return {'user': userModel, 'tokens': tokensModel};
        }
        throw Exception('Verification failed. Please try again with a valid code.');
      },
      requiresAuth: false,
    );
  }

  @override
  Future<Either<Failure, UserModel>> getProfile() async {
    return await _apiService.request<UserModel>(
      endpoint: ApiConstants.profile,
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          return UserModel.fromJson(data['user']);
        }
        throw Exception('Could not retrieve profile information.');
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> checkAuth() async {
    return await _apiService.request<UserModel>(
      endpoint: ApiConstants.checkAuth,
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          return UserModel.fromJson(data['user']);
        }
        throw Exception('Authentication check failed.');
      },
    );
  }

  @override
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    return await _apiService.request<String>(
      endpoint: ApiConstants.refreshToken,
      method: RequestMethod.post,
      data: {
        'refreshToken': refreshToken,
      },
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true && data.containsKey('accessToken')) {
          return data['accessToken'] as String;
        }
        throw Exception('Could not refresh your session.');
      },
      requiresAuth: false,
    );
  }
}
