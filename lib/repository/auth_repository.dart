import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/repository/storage_repository.dart';
import 'package:wine_delivery_app/utils/constants.dart';

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
        saveTokens(accessToken, refreshToken);
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
          saveTokens(accessToken, refreshToken);
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
      final response = await makeAuthenticatedRequest('$_baseUrl/check');

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

  Future<void> refreshAccessToken() async {
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
        await saveTokens(newAccessToken, refreshToken);
      } else {
        // Handle failed refresh (e.g., log out)
        logout();
      }
    } catch (e) {
      print('Error refreshing access token: $e');
    }
  }

  Future<http.Response> makeAuthenticatedRequest(
    String endpoint, {
    RequestMethod method = RequestMethod.get,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    String? accessToken = await getAccessToken();

    headers ??= {};
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer $accessToken';

    http.Response response;
    http.Response cachedResponse;
    try {
      response = await getResponse(method, endpoint, headers, body);
    } catch (e) {
      throw Exception('Network error: $e');
    }

    if (response.statusCode == 401) {
      // Token might be expired, try to refresh it
      await refreshAccessToken();

      // Retry the original request with the new access token
      accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';
      cachedResponse = response;

      response = await getResponse(method, endpoint, headers, body, cachedResponse);
    }

    return response;
  }

  Future<http.Response> getResponse(
    RequestMethod method,
    String endpoint,
    Map<String, String> headers,
    body, [
    http.Response? response,
  ]) async {
    response = switch (method) {
      RequestMethod.get => await http.get(Uri.parse(endpoint), headers: headers),
      RequestMethod.post => await http.post(Uri.parse(endpoint), headers: headers, body: body),
      RequestMethod.put => await http.put(Uri.parse(endpoint), headers: headers, body: body),
      RequestMethod.delete => await http.delete(Uri.parse(endpoint), headers: headers, body: body),
    };
    return response;
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
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

enum RequestMethod {
  get,
  post,
  put,
  delete,
}