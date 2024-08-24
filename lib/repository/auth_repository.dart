import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/utils/constants.dart';

import '../utils/prefs.dart';

class AuthRepository {
  AuthRepository();

  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();

  static AuthRepository getInstance() {
    return _instance;
  }

  static const String _loginUrl = '${Constants.baseUrl}/api/auth/login';

  Future<String> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      authToken = token;
      return token;
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<bool> login(String email, String password, ValueChanged<String> result) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final String? token = data['token'];

        if (token != null && token.isNotEmpty) {
          authToken = token;
          print(token);
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

  Future<String> getToken() async {
    return authToken;
  }

  Future<void> logout() async {
    // authToken = '';
    //removeAuthToken();
  }
}

final AuthRepository authRepository = AuthRepository.getInstance();
