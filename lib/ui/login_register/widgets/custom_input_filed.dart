import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputFiled extends StatelessWidget {
   const CustomInputFiled({super.key,required this.label ,required this.controller,required this.validator,this.obscureText=false});
final String label;
final String? Function(String?)? validator;
final TextEditingController controller;
final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
obscureText: obscureText,
      validator: validator,
      controller: controller,
      cursorColor: Colors.black.withValues(alpha: 0.3),
      decoration: InputDecoration(
        label: Text(label),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.5),width: 1.5.r ),borderRadius: BorderRadius.circular(10.r),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.5),width: 1.5.r ),borderRadius: BorderRadius.circular(10.r),),
        labelStyle: TextStyle(color: Colors.grey),
      ),
    );
  }
}
