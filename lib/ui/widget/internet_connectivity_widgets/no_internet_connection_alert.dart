import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget noInternetConnectionAlert() {
  return Dialog(
    child: Container(
      height: 280.h,
      width: 200.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/no_internet.svg',
            width: 100.w,
            height: 100.h,
            color: Colors.orange,
          ),
          SizedBox(height: 40.h),
          Text(
            'No Internet Connection',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 18.r,
            ),
          ),
        ],
      ),
    ),
  );
}
