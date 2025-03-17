import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/models/auth_tokens_model.dart';
import 'package:vintiora/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> register(String username, String email, String password);

  Future<String> login(String email, String password);

  Future<Map<String, dynamic>> verifyOtp(String email, String otp);

  Future<UserModel> getProfile();

  Future<UserModel> checkAuth();

  Future<String> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final IApiService _apiService;

  AuthRemoteDataSourceImpl({required IApiService apiService}) : _apiService = apiService;

  @override
  Future<String> register(String username, String email, String password) async {
    final result = await _apiService.request<Map<String, dynamic>>(
      endpoint: ApiConstants.register,
      method: RequestMethod.post,
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
      parser: (data) => data as Map<String, dynamic>,
      requiresAuth: false,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data['message'] as String,
    );
  }

  @override
  Future<String> login(String email, String password) async {
    final result = await _apiService.request<Map<String, dynamic>>(
      endpoint: ApiConstants.login,
      method: RequestMethod.post,
      data: {
        'email': email,
        'password': password,
      },
      parser: (data) => data as Map<String, dynamic>,
      requiresAuth: false,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data['message'] as String,
    );
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final result = await _apiService.request<Map<String, dynamic>>(
      endpoint: ApiConstants.verifyOtp,
      method: RequestMethod.post,
      data: {
        'email': email,
        'otp': otp,
      },
      parser: (data) => data as Map<String, dynamic>,
      requiresAuth: false,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        if (data['success'] == true) {
          final userModel = UserModel.fromJson(data['user']);
          final tokensModel = AuthTokensModel(
            accessToken: data['accessToken'],
            refreshToken: data['refreshToken'],
          );
          return {'user': userModel, 'tokens': tokensModel};
        } else {
          throw Exception('OTP verification failed');
        }
      },
    );
  }

  @override
  Future<UserModel> getProfile() async {
    final result = await _apiService.request<Map<String, dynamic>>(
      endpoint: ApiConstants.profile,
      parser: (data) => data as Map<String, dynamic>,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        if (data['success'] == true) {
          return UserModel.fromJson(data['user']);
        } else {
          throw Exception('Failed to get profile');
        }
      },
    );
  }

  @override
  Future<UserModel> checkAuth() async {
    final result = await _apiService.request<Map<String, dynamic>>(
      endpoint: ApiConstants.checkAuth,
      parser: (data) => data as Map<String, dynamic>,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        if (data['success'] == true) {
          return UserModel.fromJson(data['user']);
        } else {
          throw Exception('Authentication check failed');
        }
      },
    );
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final result = await _apiService.request<Map<String, dynamic>>(
      endpoint: ApiConstants.refreshToken,
      method: RequestMethod.post,
      data: {
        'refreshToken': refreshToken,
      },
      parser: (data) => data as Map<String, dynamic>,
      requiresAuth: false,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        if (data['success'] == true && data.containsKey('accessToken')) {
          return data['accessToken'] as String;
        } else {
          throw Exception('Failed to refresh token');
        }
      },
    );
  }
}
