import 'package:flutter/material.dart';
import 'package:os_detect/os_detect.dart' as os_detect;
import 'package:share_plus/share_plus.dart';
import 'package:vintiora/shared/widgets/custom_confirmation_dialog.dart';

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

/*  static ImageProvider<Object> networkImage(String? imagePath) {
    return conditionFunction(
      imagePath != null,
          () => NetworkImage('${Constants.baseUrl}$imagePath'),
          () => AssetImage(Constants.imagePlaceholder),
    );
  }*/

  /*static Future<void> authCheck(BuildContext context) async {
    final String endpoint = '${Constants.baseUrl}/auth/profile';
    Response response = Response(requestOptions: RequestOptions());

    try {
      response = await makeRequest(endpoint);
      final isInternetConnected = await InternetConnectionChecker().isInternetConnected; // Use DI - RepositoryProvider here

      logger.d(response);
      if (sessionActive && seenOnboarding || !isInternetConnected) {
        Nav.navigateAndRemoveUntil(Routes.main);
      } else if (response.statusCode == 200) {
        sessionActive = true;
        Nav.navigateAndRemoveUntil(Routes.main);
      } else {
        logger.w('${response.statusCode}: ${response.data}');
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
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }*/

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

var isWeb = os_detect.isBrowser;
var isAndroid = os_detect.isAndroid;
var isFuchsia = os_detect.isFuchsia;
var isIOS = os_detect.isIOS;
var isMacOS = os_detect.isMacOS;
var isWindows = os_detect.isWindows;
var isLinux = os_detect.isLinux;
var osVersion = os_detect.operatingSystemVersion;
var os = os_detect.operatingSystem;

double toDouble(dynamic value) {
  // logger.i(value.runtimeType);
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  return 0.0; // Handle other unexpected types or nulls
}
