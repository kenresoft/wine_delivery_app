import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/model/product.dart';

import '../utils/constants.dart';
import 'auth_repository.dart';

class UserRepository {
  UserRepository();
  UserRepository._();

  static final UserRepository _instance = UserRepository._();

  static UserRepository getInstance() {
    return _instance;
  }

  static const String _url = '${Constants.baseUrl}/api/auth/profile';

  Future<Profile> getUserProfile() async {
    final token = await authRepository.getToken();

    try {
      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final userJson = data['user'];

        if (userJson != null) {
          return Profile.fromJson(userJson);
        }
        throw 'Error parsing user from the server.';
      }
      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }
      throw 'Error fetching user profile: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is SocketException) {
        throw 'Failed to retrieve user information (error code: 404). \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team at [email protected].';
      }
      rethrow;
    }
  }
}

final UserRepository userRepository = UserRepository.getInstance();