import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/views/home/rate_bar.dart';

import 'clipper.dart';

class DrinksCollection extends StatelessWidget {
  const DrinksCollection({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.color,
    required this.scrollController,
    required this.onClick,
  });

  final List<String> name;
  final List<String> image;
  final List<double> price;
  final List<double> rating;
  final List<Color> color;
  final ScrollController scrollController;
  final Function(int index, DrinksCollection collection) onClick;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: name.length,
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => onClick(index, this),
          child: Container(
            width: 145.w,
            margin: const EdgeInsets.all(4.0).copyWith(
              left: index == 0 ? 15.w : 4.w,
              right: index == name.length - 1 ? 15.w : 4.w,
            ),
            child: Stack(children: [
              Positioned(
                top: 50.h,
                left: 0,
                width: 145.w,
                height: 200.h,
                child: Card(
                  color: color[index],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15).r),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10).w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name[index],
                          style: TextStyle(color: Colors.white, fontSize: 18.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text('\$${price[index]}', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                        SizedBox(height: 2.h),
                        RateBar(rating: rating[index]),
                        //Text(rating[index].toString(), style: const TextStyle(color: Colors.white)),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4.h,
                left: 33.w,
                child: CustomPaint(
                  painter: SemiCircle(),
                ),
              ),
              Positioned(
                left: -3.w,
                top: 2.h,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5).r,
                    child: Image.asset(
                      image[index],
                      height: 165.h,
                      width: 140.w,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
