import 'dart:convert';
import 'dart:io';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../repository/auth_repository.dart';
import '../views/shared/custom_confirmation_dialog.dart';
import 'helpers.dart';

class Utils {
  Utils._();

  // Helper method to get badge color based on stock status
  static Color getStockStatusColor(String stockStatus) {
    switch (stockStatus) {
      case 'In Stock':
        return Colors.green;
      case 'Out of Stock':
        return Colors.red;
      case 'Low Stock':
        return Colors.orange;
      case 'Coming Soon':
        return Colors.blue;
      default:
        return Colors.grey; // Default color for unknown statuses
    }
  }

  static ImageProvider<Object> networkImage(String? imagePath) {
    return conditionFunction(
      imagePath != null,
      () => NetworkImage('${Constants.baseUrl}$imagePath'),
      () => AssetImage(Constants.imagePlaceholder),
    );
  }

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
      throw Utils.handleError(error: e);
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

  static Future<void> authCheck(BuildContext context) async {
    // final String endpoint = '${Constants.baseUrl}/api/categories';
    final String endpoint = '${Constants.baseUrl}/api/auth/profile';
    var response = http.Response('', 404);

    try {
      response = await _makeAuthenticatedRequest(endpoint);
      final internet = await InternetConnectionChecker().internetResult();

      if (sessionActive && seenOnboarding || !internet.hasInternetAccess) {
        Nav.navigateAndRemoveUntil(Routes.main);
      }

      if (response.statusCode == 200) {
        sessionActive = true;
        Nav.navigateAndRemoveUntil(Routes.main);
      } else {
        // Handle error here
        logger.w('${response.statusCode}: ${response.body}');
        Nav.navigateAndRemoveUntil(Routes.login);
      }
    } on NoAccessTokenException catch (e) {
      sessionActive = false;
      logger.e(e.message);
      Nav.navigateAndRemoveUntil(Routes.login);
    } on NoRefreshTokenException catch (e) {
      sessionActive = false;
      logger.e(e.message);
      Nav.navigateAndRemoveUntil(Routes.login);
    } on SocketException catch (e) {
      logger.d(e);
      Nav.navigateAndRemoveUntil(Routes.main);
    } catch (e) {
      // logger.e(e);
      throw Utils.handleError(response: response, error: e);
    }
  }

  static Future<http.Response> _makeAuthenticatedRequest(String endpoint) async {
    return authRepository.makeAuthenticatedRequest(endpoint);
  }

  // Handle errors based on status code
  static AppException handleError({http.Response? response, Object? error, void Function(String message)? cb}) {
    // logger.w(error.runtimeType);
    if (response != null) {
      final message = jsonDecode(response.body)['message'];
      cb?.call(message);
      logger.e(message);
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
    } else {
      if (error is SocketException) {
        return const NetworkErrorException('Network error, please try again later.');
      } else {
        return UnexpectedException(error.toString());
      }
    }
  }

  static Future<bool?> dialog(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmButtonText,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) async {
    return await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: title,
          content: content,
          cancelButtonText: 'Cancel',
          confirmButtonText: confirmButtonText,
          onCancel: onCancel,
          onConfirm: onConfirm,
        );
      },
    );
  }

  static void shareProduct(String name, String description, String imageUrl, String productUrl) {
    final String shareContent = 'Check out this product:\n\n$name\n\n$description\n\nImage: $imageUrl\n\nMore details: $productUrl';
    Share.share(shareContent);
  }
}
