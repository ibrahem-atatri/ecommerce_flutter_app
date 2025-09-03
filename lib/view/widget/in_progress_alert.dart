import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget InProgressAlert() {
  return Dialog(
    child: Container(
      height: 280.h,
      width: 200.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_sharp, color: Colors.teal, size: 60.r),
          SizedBox(height: 40.h),
          Text(
            'Will be available soon...',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 18.r,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
    ),
  );
}
