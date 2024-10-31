import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/repository/storage_repository.dart';
import 'package:wine_delivery_app/repository/user_repository.dart';

import '../utils/helpers.dart';

class AuthRepository {
  AuthRepository();

  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();

  static AuthRepository getInstance() {
    return _instance;
  }

  static final String _baseUrl = '${Constants.baseUrl}/api/auth';

  Future<bool> register(String username, String email, String password, ValueChanged<String> message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        sessionActive = false;
        message('User registered successfully');
        return true;
      }

      message('Failed to register user: ${response.statusCode} - ${data['message']}');
      return false;
    } catch (e) {
      logger.e(e.toString());
      if (e is SocketException) {
        message('Failed to retrieve user information (error code: 404). \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team at kenresoft@gmail.com.');
      }
      return false;
    }
  }

  Future<bool> login(String email, String password, ValueChanged<String> message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final String? messageData = data['message'];

        if (messageData != null && messageData.isNotEmpty) {
          otpSent = true;
          logger.i(messageData);
          message('Otp sent!');
          return true;
        }
        message('Error verifying user identity.');
        return false;
      }
      if (response.statusCode == 401) {
        message(data['message']);
        return false;
      }
      message('Error logging in user: ${response.statusCode} - ${response.reasonPhrase}');
      return false;
    } catch (e) {
      logger.e(e.toString());
      if (e is SocketException) {
        message('Failed to retrieve user information (error code: 404). \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team at kenresoft@gmail.com.');
      }
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp, ValueChanged<String> result) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final String? accessToken = data['accessToken'];
        final String? refreshToken = data['refreshToken'];
        final String? userId = data['user']['id'];
        logger.d(userId);

        if (accessToken != null && accessToken.isNotEmpty && refreshToken != null && refreshToken.isNotEmpty) {
          await userRepository.initializeDeviceToken();
          await _saveTokens(accessToken, refreshToken);
          sessionActive = true;
          result('OTP verified successfully!');
          return true;
        }
        result('Error verifying OTP.');
        return false;
      }

      result(data['message']);
      return false;
    } catch (e) {
      result('Error: $e');
      return false;
    }
  }


  Future<bool> checkAuthStatus() async {
    final token = await getAccessToken();

    if (token.isEmpty) {
      sessionActive = false;
      return false;
    }

    try {
      final response = await Utils.makeRequest('$_baseUrl/check');

      switch (response.statusCode) {
        case 200:
          return true;
        case 401:
          // Unauthorized - Token might be invalid or expired
          await clearToken();
          sessionActive = false;
          return false;
        default:
          logger.e('Unexpected status code: ${response.statusCode}');
          sessionActive = false;
          return false;
      }
    } on SocketException {
      logger.w('No Internet connection');
      return false;
    } catch (e) {
      logger.e('Error checking auth status: $e');
      return false;
    }
  }

  Future<http.Response> makeAuthenticatedRequest(String endpoint) async {
    await _checkTokenExpiry();

    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      sessionActive = false;
      throw const NoAccessTokenException('No access token available');
    }

    return Utils.makeRequest(endpoint);
  }

  /// Checks if access token is about to expire and refreshes if necessary
  Future<void> _checkTokenExpiry() async {
    final accessToken = await getAccessToken();

    if (accessToken.isEmpty) return;

    final payload = _decodePayload(accessToken);
    final expirationTime = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
    final currentTime = DateTime.now();

    final timeToExpire = expirationTime.difference(currentTime).inSeconds;

    if (timeToExpire < Constants.tokenRefreshThreshold) {
      await _refreshAccessToken();
    }
  }

  /// Refreshes the access token
  Future<void> _refreshAccessToken() async {
    final String refreshToken = await getRefreshToken();

    if (refreshToken.isEmpty) {
      // Handle absence of refresh token (e.g., navigate to login)
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        // final newRefreshToken = data['refreshToken'];
        await _saveTokens(newAccessToken, refreshToken);
      } else if (response.statusCode == 401) {
        sessionActive = false;
        throw const NoRefreshTokenException('Error refreshing access token');
      } else {
        // Handle failed refresh (e.g., log out)
        logout();
      }
    } catch (e) {
      throw NoAccessTokenException('Error refreshing access token: $e');
    }
  }

  /// Decodes JWT token payload
  Map<String, dynamic> _decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return jsonDecode(payload);
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    return await storageRepository.saveTokens(accessToken, refreshToken);
  }

  Future<String> getAccessToken() async {
    return await storageRepository.getAccessToken();
  }

  Future<String> getRefreshToken() async {
    return await storageRepository.getRefreshToken();
  }

  Future<void> clearToken() async {
    sessionActive = false;
    return await storageRepository.clearTokens();
  }

  Future<void> logout() async {
    sessionActive = false;
  }
}

final AuthRepository authRepository = AuthRepository.getInstance();