import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/view/log_in/log_in_view.dart';
import 'package:ecommerce_app/view/widget/custom_button_widget.dart';
import 'package:ecommerce_app/view/widget/custom_input_filed.dart';
import 'package:ecommerce_app/view/widget/oauth_button.dart';
import 'package:ecommerce_app/view_model/auth_view_model.dart';
import 'package:ecommerce_app/view_model/register_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterView extends ConsumerWidget {
  RegisterView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegisterViewModel registerViewModel = RegisterViewModel();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    ref.listen(authViewModelProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data != null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainApp()),
              (route) => false,
            );
          }
        },
        error: (error, stackTrace) {
          final message;
          // error is FirebaseAuthException ? (error.message ?? "Authentication error"):error.toString();
          if (error is FirebaseAuthException) {
            if (error.code == 'weak-password') {
              message = 'The password provided is too weak.';
            } else if (error.code == 'email-already-in-use') {
              message = 'The account already exists for that email.';
            } else {
              message = 'there are an error exist while register, ${error.message}';
            }
          } else {
            message = error.toString();
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
        loading: () {},
      );
    });
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 30.0.w,vertical: 30.h),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    color: Colors.orange[500],
                    size: 45.r,
                    weight: 800,
                  ),
                  Text(
                    'Shop',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 25.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Align(
                    child: Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(height: 12.h),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomInputFiled(
                          label: 'User Name',
                          validator:
                              (value) =>
                                  registerViewModel.validateUsername(value),
                          controller: registerViewModel.userNameController,
                        ),
                        SizedBox(height: 15.h),
                        CustomInputFiled(
                          label: 'Email',
                          validator:
                              (value) => registerViewModel.validateEmail(value),
                          controller: registerViewModel.emailController,
                        ),
                        SizedBox(height: 15.h),
                        CustomInputFiled(
                          label: 'Password',
                          validator:
                              (value) =>
                                  registerViewModel.validatePassword(value),
                          controller: registerViewModel.passwordController,
                          obscureText: true,
                        ),
                        SizedBox(height: 15.h),
                        CustomInputFiled(
                          label: 'Confirm Password',
                          validator:
                              (value) => registerViewModel
                                  .validateConfirmPassword(value),
                          controller:
                              registerViewModel.confirmPasswordController,
                          obscureText: true,
                        ),
                        SizedBox(height: 15.h),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LogInView(),
                              ),
                            );
                          },
                          child: Text('I have an account'),
                        ),
                        SizedBox(height: 60.h),

                        CustomButtonWidget(
                          onTap: () {
                            ref
                                .read(authViewModelProvider.notifier)
                                .register(
                                  formKey,
                                  registerViewModel.emailController.text,
                                  registerViewModel.passwordController.text,
                                  registerViewModel.userNameController.text,
                                );
                          },
                          title: 'Register',
                          buttonState: authState.isLoading,
                        ),
                        SizedBox(height: 40.h),
                        Text('-Or sign up with -'),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OauthButton(
                              path: 'assets/google.svg',
                              onTap: () async {
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .signInUsingGoogle();
                              },
                            ),
                            OauthButton(
                              path: 'assets/facebook.svg',
                              onTap: () async {
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .signInUsingFacebook();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
