import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:wine_delivery_app/repository/decision_repository_v2.dart';

import '../model/profile.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'auth_repository.dart';

class UserRepository {
  UserRepository();
  UserRepository._();

  static final UserRepository _instance = UserRepository._();

  static UserRepository getInstance() {
    return _instance;
  }

  static final String _url = '${Constants.baseUrl}/api/auth/profile';

  static final String _updateUrl = '${Constants.baseUrl}/api/users/';

  Future<Profile> getUserProfile() async {
    return DecisionRepository().decide(
      cacheKey: 'getUserProfile',
      endpoint: _url,
      onSuccess: (data) async {
        final userJson = data['user'];

        if (userJson != null) {
          return Profile.fromJson(userJson);
        }
        throw 'Error parsing user from the server.';
      },
      onError: (error) async {
        logger.e('ERROR: ${error.toString()}');
        return const Profile(id: 'id', email: 'email', username: 'username', profileImage: 'profileImage', favorites: []);
      },
    );

    /*try {
      final response = await Utils.makeRequest(_url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final userJson = data['user'];

        if (userJson != null) {
          return Profile.fromJson(userJson);
        }
        throw 'Error parsing user from the server.';
      }
      if (response.statusCode == 401) {
        throw const InvalidAccessTokenException('Unauthorized: Please log in again.');
      }
      if (response.statusCode == 403) {
        throw const UnauthorizedException('Unauthorized: Access Denied');
      }
      throw 'Error fetching user profile: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      if (kDebugMode) {
        logger.e(e.toString());
      }
      if (e is SocketException) {
        throw const NetworkException('Failed to retrieve user information (error code: 404). \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team at [email protected].');
      }
      rethrow;
    }*/
  }

  // New Method to Update User Profile
  Future<Profile> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updatedData,
    File? profileImage, // Optional profile image
  }) async {
    final token = await authRepository.getAccessToken();

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
          contentType: MediaType('image', 'jpeg'),
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
        logger.e(e.toString());
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