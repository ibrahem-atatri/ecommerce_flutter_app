import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonWidget extends StatelessWidget {
   CustomButtonWidget({super.key,required this.title,required this.onTap, this.buttonState = false,this.buttonWidget});
final String title;
final bool buttonState ;
final Widget? buttonWidget;
void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.orange[500],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: buttonState == true ? CircularProgressIndicator(color: Colors.white,) :
          buttonWidget != null ? buttonWidget :Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.r,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
