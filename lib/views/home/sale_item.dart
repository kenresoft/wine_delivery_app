import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/views/product/rate_bar.dart';

class SaleItem extends StatelessWidget {
  const SaleItem({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.color,
  });

  final String name;
  final String image;
  final double price;
  final double rating;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 60.h,
        left: 10.w,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 20.w,
          height: 105.h,
          child: Card(
            color: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15).r),
            child: Padding(
              padding: EdgeInsets.only(left: 80.w, right: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.white, fontSize: 17.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text('\$$price', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                  SizedBox(height: 2.h),
                  RateBar(rating: rating),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 15.h,
        left: -14.w,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            image,
            height: 155.h,
            width: 140.w,
          ),
        ),
      ),
    ]);
  }
}
