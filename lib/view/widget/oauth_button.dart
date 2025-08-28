import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OauthButton extends StatelessWidget {
   OauthButton({super.key,required this.path,required this.onTap});
final String path;
final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        child:SvgPicture.asset(path,width: 30.w,height: 30.h,),
        padding:EdgeInsets.symmetric(horizontal: 22.w,vertical: 7.h),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.r)
        ),
      ),
    );
  }
}
