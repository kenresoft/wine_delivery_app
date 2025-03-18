import 'dart:convert';
import 'dart:io';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/extensions.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';

import '../models/responses/profile.dart';

class UserRepository {
  UserRepository._();

  static final UserRepository _instance = UserRepository._();

  static UserRepository getInstance() => _instance;

  static final String _url = '${ApiConstants.baseUrl}/auth/profile';

  static final String _updateUrl = '${ApiConstants.baseUrl}/users';

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
    final apiService = GetIt.I<IApiService>();

    final result = await apiService.request(
      endpoint: '$_updateUrl/deviceToken',
      method: RequestMethod.put,
      data: {'deviceToken': deviceToken},
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (failure) => logger.e("Failed to send device token: ${failure.message}"),
      (data) => logger.i("Device token successfully sent to the backend"),
    );
  }

  /// Retrieve user profile
  Future<Profile> getUserProfile() async {
    final apiService = GetIt.I<IApiService>();
    final result = await apiService.request(
      endpoint: _url,
      parser: (data) => data as Map<String, dynamic>,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        if (data['success'] == true) {
          return Profile.fromJson(data['user']);
        } else {
          throw Exception('Error parsing user data from the server.');
        }
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
    final token = await AuthLocalDataSourceImpl().getAccessToken();
    final uri = Uri.parse('$_updateUrl/$userId');

    try {
      var request = http.MultipartRequest('PUT', uri)..headers['Authorization'] = 'Bearer $token';

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
        final data = jsonDecode(response.body);
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
