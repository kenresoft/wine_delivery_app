import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

  static const String _updateUrl = '${Constants.baseUrl}/api/users/';

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

  // New Method to Update User Profile
  Future<Profile> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updatedData,
    File? profileImage, // Optional profile image
  }) async {
    final token = await authRepository.getToken();

    try {
      final uri = Uri.parse('$_updateUrl/$userId');
      var request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token';

      // Add updated fields to the request
      updatedData.forEach((key, value) {
        request.fields[key] = value;
      });

      // If there's a profile image, add it to the request
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          profileImage.path,
          contentType: MediaType('image', 'jpeg'), // Adjust based on the image type
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final  data = jsonDecode(response.body);
        final userJson = data['user'];

        if (userJson != null) {
          return Profile.fromJson(userJson);
        }
        throw 'Error parsing updated user data from the server.';
      }
      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }
      throw 'Error updating user profile: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is SocketException) {
        throw 'Failed to update user information. \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team.';
      }
      rethrow;
    }
  }
}

final UserRepository userRepository = UserRepository.getInstance();