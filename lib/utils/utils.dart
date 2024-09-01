import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wine_delivery_app/utils/app_theme.dart';

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
