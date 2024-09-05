import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/utils/app_theme.dart';
import 'package:wine_delivery_app/views/auth/login_page.dart';

import '../repository/auth_repository.dart';
import 'constants.dart';

extension ToastExtension on String {
  void get toast {
    Fluttertoast.showToast(
      msg: toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: AppTheme().themeData.colorScheme.primary,
      // backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 18,
    );
  }

  void toasts(BuildContext context) {
    FToast().init(context).showToast(
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 8),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff383838),
              borderRadius: BorderRadius.circular(15),
            ),
            //constraints: BoxConstraints(maxWidth: .8.sw),
            padding: const EdgeInsets.all(10).r,
            child: FittedBox(
              //constrainedAxis: Axis.vertical,
              child: SizedBox(
                width: .6.sw,
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.check_mark, color: Colors.green),
                    Text(
                      this,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(color: Colors.white, fontSize: 15.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}

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

  static Future<void> authCheck(BuildContext context) async {
    const String endpoint = '${Constants.baseUrl}/api/categories';
    try {
      final response = await authRepository.makeAuthenticatedRequest(endpoint);
      if (response.statusCode == 200) {
        /*final data = response.body;
        print(data.isNotEmpty);*/
        return;
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
    } catch (e) {
      print(e);
    }
  }
}

enum RequestMethod {
  get,
  post,
  put,
  delete,
}