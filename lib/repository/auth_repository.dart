import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/utils/constants.dart';

import '../utils/prefs.dart';

class AuthRepository {
  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();

  // Getter for the singleton instance
  static AuthRepository getInstance() {
    return _instance;
  }

  AuthRepository();

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

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      //if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        authToken = token;
        print(token);
        return token;
      //} else {
        //return '';
        //throw print('Failed to log in');
      //}
    } catch (error) {
      print('ERROR: $error');
      return '';
    }
  }

  Future<String> getToken() async {
    return authToken;
  }

  Future<void> logout() async {
    removeAuthToken(authToken);
  }
}

final AuthRepository authRepository = AuthRepository.getInstance();
