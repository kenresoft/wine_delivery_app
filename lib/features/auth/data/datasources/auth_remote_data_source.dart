import 'package:dio/dio.dart';
import 'package:vintiora/core/network/api_service.dart';

import '../../core/utils/constants.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> register(String username, String email, String password);

  Future<String> login(String email, String password);

  Future<Map<String, dynamic>> verifyOtp(String email, String otp);

  Future<UserModel> getProfile();

  Future<UserModel> checkAuth();

  Future<String> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<String> register(String username, String email, String password) async {
    try {
      final response = await apiService.makeRequest(
        ApiConstants.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'];
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await apiService.makeRequest(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await apiService.makeRequest(
        ApiConstants.verifyOtp,
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          final userModel = UserModel.fromJson(response.data['user']);
          final tokensModel = AuthTokensModel(
            accessToken: response.data['accessToken'],
            refreshToken: response.data['refreshToken'],
          );
          return {'user': userModel, 'tokens': tokensModel};
        } else {
          throw Exception('OTP verification failed');
        }
      } else {
        throw Exception(response.data['message'] ?? 'OTP verification failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'OTP verification failed');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await apiService.makeRequest(
        ApiConstants.profile,
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          return UserModel.fromJson(response.data['user']);
        } else {
          throw Exception('Failed to get profile');
        }
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get profile');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get profile');
    }
  }

  @override
  Future<UserModel> checkAuth() async {
    try {
      final response = await apiService.makeRequest(
        ApiConstants.checkAuth,
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          return UserModel.fromJson(response.data['user']);
        } else {
          throw Exception('Authentication check failed');
        }
      } else {
        throw Exception(response.data['message'] ?? 'Authentication check failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Authentication check failed');
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await apiService.makeRequest(
        ApiConstants.refreshToken,
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          return response.data['accessToken'];
        } else {
          throw Exception('Token refresh failed');
        }
      } else {
        throw Exception(response.data['message'] ?? 'Token refresh failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Token refresh failed');
    }
  }
}
