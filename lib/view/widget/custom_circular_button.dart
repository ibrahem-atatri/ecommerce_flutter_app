import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCircularButton extends StatelessWidget {
  const CustomCircularButton({super.key,required this.text,required this.onTap});
final text ;
final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: onTap,
      child: Container(
        width: 30.r,
        height: 30.r,
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.r,
            ),
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orange.shade500,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
