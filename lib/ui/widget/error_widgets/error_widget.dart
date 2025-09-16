import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget errorWidget({required String message, required mainColor}) {
  return  Container(
    height: 200.r,
    width: 1.sw,
    padding:EdgeInsets.only(top: 20),
    // 200.r,
    decoration: BoxDecoration(
      color: mainColor,
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.none,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
         Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: 45.r,
          ),
        SizedBox(height: 20,),
        Center(
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
      ],
    ),
  );
}
