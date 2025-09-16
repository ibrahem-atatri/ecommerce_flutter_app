import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget errorAlert({required String message, required mainColor}) {
  return Dialog(
    backgroundColor: Colors.white.withAlpha(0),
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 200.r,
          width: 1.sw * 0.8,
          // 200.r,
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          clipBehavior: Clip.none,
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
        Positioned(
            left: (1.sw * 0.4) - 37.5.r ,
            top: -35.h,
            child: Container(
              width: 75.r,
              height: 75.r,
              decoration: BoxDecoration(
                  color: mainColor,
                  border: Border.all(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 70,
              ),
            ))
      ],
    ),
  );
}
