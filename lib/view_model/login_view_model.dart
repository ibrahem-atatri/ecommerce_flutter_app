import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginViewModel {

  TextEditingController? emailController = TextEditingController(text: '');
  TextEditingController? passwordController = TextEditingController(text: '');

  // Email Validator
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Password Validator

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

}
