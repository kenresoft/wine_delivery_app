import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vintiora/core/utils/constants.dart';
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

  static ImageProvider<Object> networkImage(String? imagePath) {
    return conditionFunction(
      imagePath != null,
      () => NetworkImage('${Constants.baseUrl}$imagePath'),
      () => AssetImage(Constants.imagePlaceholder),
    );
  }

  /*static Future<void> authCheck(BuildContext context) async {
    final String endpoint = '${Constants.baseUrl}/api/auth/profile';
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
