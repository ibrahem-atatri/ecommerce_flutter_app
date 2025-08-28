import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget HeaderText({required double screenWidth, required String text}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),
  );
}
