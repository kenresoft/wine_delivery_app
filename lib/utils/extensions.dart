import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'enums.dart';
import 'themes.dart';

// Extension to compare DateTime objects by date only
extension DateTimeComparison on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension ToastExtension<T> on T {
  T get toast {
    Fluttertoast.showToast(
      msg: toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      //backgroundColor: AppTheme().themeData.colorScheme.primary,
      textColor: Colors.white,
      fontSize: 18,
    );
    return this;
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
                      toString(),
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

extension WineCategoryExtension on WineCategory {
  String get displayName {
    return switch (this) {
      WineCategory.red => 'Red',
      WineCategory.white => 'White',
      WineCategory.rose => 'Rosé',
      WineCategory.sparkling => 'Sparkling',
      WineCategory.dessert => 'Dessert',
      WineCategory.fortified => 'Fortified',
      WineCategory.organic => 'Organic',
      WineCategory.biodynamic => 'Biodynamic',
      WineCategory.natural => 'Natural',
      WineCategory.kosher => 'Kosher',
      WineCategory.lowSulfur => 'Low Sulfur',
      WineCategory.nonAlcoholic => 'Non-Alcoholic',
      WineCategory.vegan => 'Vegan',
    };
  }

  IconData get icon {
    return switch (this) {
      WineCategory.red => Icons.local_bar,
      WineCategory.white => Icons.wine_bar,
      WineCategory.rose => Icons.local_drink,
      WineCategory.sparkling => Icons.bubble_chart,
      WineCategory.dessert => Icons.cake,
      WineCategory.fortified => Icons.wine_bar,
      WineCategory.organic => Icons.eco,
      WineCategory.biodynamic => Icons.grass,
      WineCategory.natural => Icons.nature,
      WineCategory.kosher => CupertinoIcons.staroflife,
      WineCategory.lowSulfur => Icons.filter_alt,
      WineCategory.nonAlcoholic => Icons.no_drinks,
      WineCategory.vegan => CupertinoIcons.tree,
    };
  }
}

extension OrderStatusExtension on OrderStatus {
  String toShortString() {
    switch (this) {
      case OrderStatus.draft:
        return 'Draft';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.packaging:
        return 'Packaging';
      case OrderStatus.shipping:
        return 'Shipping';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return OrderStatus.draft;
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'packaging':
        return OrderStatus.packaging;
      case 'shipping':
        return OrderStatus.shipping;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        throw ArgumentError('Invalid OrderStatus string: $value');
    }
  }
}

extension StringExtensions on String? {
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }
}