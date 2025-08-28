import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterViewModel {
  TextEditingController userNameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController = TextEditingController(
    text: '',
  );

  // Username Validator
  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

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
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // You can make it stronger (upper, lower, digit, special char)
    final strongRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).+$',
    );
    if (!strongRegex.hasMatch(value)) {
      return 'Password must contain upper, lower, number, and special character';
    }
    return null;
  }

  // Confirm Password Validator
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != this.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
