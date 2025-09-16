import 'package:ecommerce_app/ui/login_register/widgets/custom_input_filed.dart';
import 'package:ecommerce_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key,required this.userNameController,required this.emailController,required this.passwordController,required this.confirmPasswordController});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController ;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final TextEditingController confirmPasswordController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputFiled(
          label: 'User Name',
          validator: (value) => FormValidator.validateUsername(value),
          controller: userNameController,
        ),
        SizedBox(height: 15.h),
        CustomInputFiled(
          label: 'Email',
          validator: (value) => FormValidator.validateEmail(value),
          controller: emailController,
        ),
        SizedBox(height: 15.h),
        CustomInputFiled(
          label: 'Password',
          validator: (value) => FormValidator.validatePassword(value),
          controller: passwordController,
          obscureText: true,
        ),
        SizedBox(height: 15.h),
        CustomInputFiled(
          label: 'Confirm Password',
          validator:
              (value) => FormValidator.validateConfirmPassword(password: passwordController.text,confirmPassword: value),
          controller: confirmPasswordController,
          obscureText: true,
        ),

        // CustomButtonWidget(
        //   onTap: () {
        //     ref
        //         .read(authViewModelProvider.notifier)
        //         .register(
        //           formKey,
        //           registerViewModel.emailController.text,
        //           registerViewModel.passwordController.text,
        //           registerViewModel.userNameController.text,
        //         );
        //   },
        //   title: 'Register',
        //   buttonState: authState.isLoading,
        // ),

      ],
    );
  }
}
