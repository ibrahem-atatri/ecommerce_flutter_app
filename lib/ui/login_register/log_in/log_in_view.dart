import 'package:ecommerce_app/ui/login_register/widgets/custom_input_filed.dart';
import 'package:ecommerce_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogInView extends StatelessWidget {
  LogInView({super.key,required this.emailController,required this.passwordController});
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        CustomInputFiled(
          label: 'Email',
          controller: emailController,
          validator:
              (value) => FormValidator.validateEmail(value),
        ),
        SizedBox(height: 15.h),
        CustomInputFiled(
          label: 'Password',
          controller: passwordController,
          validator:(value) =>FormValidator.validateLogInPassword(value),
          obscureText: true,
        ),


      ],
    );
  }
}
