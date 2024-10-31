import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../model/profile.dart';
import '../utils/helpers.dart';
import 'auth_repository.dart';
import 'decision_repository.dart';

class UserRepository {
  UserRepository._();

  static final UserRepository _instance = UserRepository._();

  static UserRepository getInstance() => _instance;

  static final String _url = '${Constants.baseUrl}/api/auth/profile';

  static final String _updateUrl = '${Constants.baseUrl}/api/users';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize device token and listen for token changes
  Future<void> initializeDeviceToken() async {
    // Request permission on iOS
    await _firebaseMessaging.requestPermission();

    // Retrieve the device token
    String? token = await _firebaseMessaging.getToken();
    logger.w(token);

    if (token != null) {
      await sendDeviceTokenToBackend(token);
    }

    // Listen for token refresh events
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      if (!newToken.isNullOrEmpty) {
        await sendDeviceTokenToBackend(newToken);
      }
    });
  }

  /// Send device token to backend for storage in the user profile
  Future<void> sendDeviceTokenToBackend(String deviceToken) async {
    final authToken = await authRepository.getAccessToken();

    final url = Uri.parse('$_updateUrl/deviceToken');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'deviceToken': deviceToken}),
      );

      if (response.statusCode == 200) {
        logger.i("Device token successfully sent to the backend");
      } else {
        logger.e("Failed to send device token: ${(jsonDecode(response.body) as Map<String, dynamic>)['message']}");
      }
    } catch (error) {
      logger.e("Error sending device token to backend: $error");
    }
  }

  /// Retrieve user profile
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
        return Profile.empty();
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

  /// Update user profile, with optional profile image
  Future<Profile> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updatedData,
    File? profileImage,
  }) async {
    final token = await authRepository.getAccessToken();
      final uri = Uri.parse('$_updateUrl/$userId');

    try {
      var request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token';

      // Add fields
      updatedData.forEach((key, value) {
        request.fields[key] = value;
      });

      // Attach profile image if provided
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
        if (response.statusCode == 401) {
          throw 'Unauthorized: Please log in again.';
        }
        // return Profile.empty();
        throw response.body;
        // throw 'Error updating user profile: ${response.statusCode} - ${response.reasonPhrase}';
        // throw 'Error parsing updated user data from the server.';
      } else {
        throw 'Error updating profile: ${response.body}';
      }
    } catch (e) {
      if (kDebugMode) {
        logger.e(e.toString());
      }
      if (e is SocketException) {
        throw 'Failed to update user profile. Check your internet connection.';
      }
      rethrow;
    }
  }
}

final UserRepository userRepository = UserRepository.getInstance();