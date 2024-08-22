import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/model/product.dart';
import 'package:wine_delivery_app/utils/constants.dart';

import 'auth_repository.dart';

class UserRepository {
  UserRepository._();

  static final UserRepository _instance = UserRepository._();

  // Getter for the singleton instance
  static UserRepository getInstance() {
    return _instance;
  }

  UserRepository();

  Future<Profile> getUserProfile() async {
    final token = await authRepository.getToken();
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/auth/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userJson = data['user'];
      return Profile.fromJson(userJson);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}

final UserRepository userRepository = UserRepository.getInstance();