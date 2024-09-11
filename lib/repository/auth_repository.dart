import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/repository/storage_repository.dart';
import 'package:wine_delivery_app/utils/constants.dart';
import 'package:wine_delivery_app/utils/app_exception.dart';

import '../utils/utils.dart';

class AuthRepository {
  AuthRepository();

  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();

  static AuthRepository getInstance() {
    return _instance;
  }

  static const String _baseUrl = '${Constants.baseUrl}/api/auth';

  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String? accessToken = data['accessToken'];
      final String? refreshToken = data['refreshToken'];

      if (accessToken != null && accessToken.isNotEmpty && refreshToken != null && refreshToken.isNotEmpty) {
        _saveTokens(accessToken, refreshToken);
        return true;
      }
      return false;
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<bool> login(String email, String password, ValueChanged<String> result) async {
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
        final String? accessToken = data['accessToken'];
        final String? refreshToken = data['refreshToken'];

        if (accessToken != null && accessToken.isNotEmpty && refreshToken != null && refreshToken.isNotEmpty) {
          _saveTokens(accessToken, refreshToken);
          print(accessToken);
          result('Login successful!');
          return true;
        }
        result('Error verifying user identity.');
        return false;
      }
      if (response.statusCode == 401) {
        result(data['message']);
        return false;
      }
      result('Error logging in user: ${response.statusCode} - ${response.reasonPhrase}');
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is SocketException) {
        result('Failed to retrieve user information (error code: 404). \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team at [email protected].');
      }
      return false;
    }
  }

  Future<bool> checkAuthStatus() async {
    final token = await getAccessToken();

    if (token.isEmpty) {
      return false;
    }

    try {
      final response = await makeRequest('$_baseUrl/check');

      switch (response.statusCode) {
        case 200:
          return true;
        case 401:
          // Unauthorized - Token might be invalid or expired
          await clearToken();
          return false;
        default:
          print('Unexpected status code: ${response.statusCode}');
          return false;
      }
    } on SocketException {
      print('No Internet connection');
      return false;
    } catch (e) {
      print('Error checking auth status: $e');
      return false;
    }
  }

  Future<http.Response> makeAuthenticatedRequest(String endpoint) async {
    await _checkTokenExpiry();

    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw const NoAccessTokenException('No access token available');
    }

    return makeRequest(endpoint);
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

      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        // final newRefreshToken = data['refreshToken'];
        await _saveTokens(newAccessToken, refreshToken);
      } else {
        // Handle failed refresh (e.g., log out)
        logout();
      }
    } catch (e) {
      print('Error refreshing access token: $e');
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
    return await storageRepository.clearTokens();
  }

  Future<void> logout() async {}
}

final AuthRepository authRepository = AuthRepository.getInstance();