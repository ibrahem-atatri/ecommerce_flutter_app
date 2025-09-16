
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DarkLightTheme {
  static final  lightTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSwatch().copyWith(primary:AppColors.lightenPrimary,secondary:AppColors.lightenSecondry,brightness: Brightness.light)

  );
  static final darkTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: Colors.black12,
  colorScheme: ColorScheme.fromSwatch().copyWith(primary:AppColors.darkenPrimary,secondary:AppColors.darkenSecondry,brightness: Brightness.dark)

  );
}