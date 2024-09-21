import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:wine_delivery_app/utils/exceptions.dart';
import 'package:wine_delivery_app/views/auth/login_page.dart';
import 'package:wine_delivery_app/views/home/main_screen.dart';

import '../repository/auth_repository.dart';
import 'constants.dart';
import 'enums.dart';

final logger = Logger();

class Utils {
  Utils._();

/// API Request Wrapper
  static Future<http.Response> makeRequest(
    String endpoint, {
    RequestMethod method = RequestMethod.get,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    String accessToken = await authRepository.getAccessToken();

    headers ??= {};
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer $accessToken';

    http.Response response;
    try {
      response = await _getResponse(method, endpoint, headers, body);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  static Future<http.Response> _getResponse(
    RequestMethod method,
    String endpoint,
    Map<String, String> headers,
    body,
  ) async {
    return switch (method) {
      RequestMethod.get => await http.get(Uri.parse(endpoint), headers: headers),
      RequestMethod.post => await http.post(Uri.parse(endpoint), headers: headers, body: body),
      RequestMethod.put => await http.put(Uri.parse(endpoint), headers: headers, body: body),
      RequestMethod.delete => await http.delete(Uri.parse(endpoint), headers: headers, body: body),
    };
  }

  /*static Future<void> authCheck(BuildContext context) async {
    const String endpoint = '${Constants.baseUrl}/api/categories';
    try {
      final response = await authRepository.makeAuthenticatedRequest(endpoint);
      if (response.statusCode == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const MainScreen();
          },
        ),
      );
    } else {
        // Handle error here
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const LoginPage();
            },
          ),
        );
      }
    } on NoAccessTokenException catch (e) {
      print(e.message);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ),
      );
    } on NoRefreshTokenException catch (e) {
      print(e.message);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }*/

  static Future<void> authCheck(BuildContext context) async {
    final String endpoint = '${Constants.baseUrl}/api/categories';

    try {
      final response = await _makeAuthenticatedRequest(endpoint);

      if (response.statusCode == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const MainScreen();
            },
          ),
        );
      } else {
        // Handle error here
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const LoginPage();
            },
          ),
        );
      }
    } on NoAccessTokenException catch (e) {
      logger.e(e.message);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ),
      );
    } on NoRefreshTokenException catch (e) {
      logger.e(e.message);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ),
      );
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<http.Response> _makeAuthenticatedRequest(String endpoint) async {
    return authRepository.makeAuthenticatedRequest(endpoint);
  }

  // Handle errors based on status code
  static AppException handleError(http.Response response, [String? error]) {
    switch (response.statusCode) {
      case 400:
        return const BadRequestException('Bad request, please check your input.');
      case 401:
        return const InvalidAccessTokenException('Invalid access token. Please log in again.');
      case 403:
        return const UnauthorizedException('Unauthorized: Access Denied.');
      case 404:
        return const NotFoundException('Resource not found.');
      case 500:
        return const ServerErrorException('Internal server error, please try again later.');
      default:
        return UnexpectedException('Unexpected error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
