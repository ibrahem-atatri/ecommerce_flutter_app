import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/view/register/register_view.dart';
import 'package:ecommerce_app/view/widget/custom_button_widget.dart';
import 'package:ecommerce_app/view/widget/custom_input_filed.dart';
import 'package:ecommerce_app/view/widget/oauth_button.dart';
import 'package:ecommerce_app/view_model/auth_view_model.dart';
import 'package:ecommerce_app/view_model/login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogInView extends ConsumerWidget {
  LogInView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  LoginViewModel loginViewModel = LoginViewModel();
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
          // = error is FirebaseAuthException ? (error.message ?? "Authentication error"):error.toString();
          if (error is FirebaseAuthException) {
            if (error.code == 'user-not-found') {
              message = 'No user found for that email.';
            } else if (error.code == 'wrong-password') {
              message = 'Wrong password provided for that user.';
            } else {
              message = 'An error occurred: ${error.code}';
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
          padding:  EdgeInsets.symmetric(horizontal: 30.0.w),
          child: Expanded(
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
                    SizedBox(height: 50.h),
                    Align(
                      child: Text(
                        'Login to Your Account',
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
                            label: 'Email',
                            controller:
                                loginViewModel.emailController
                                    as TextEditingController,
                            validator:
                                (value) => loginViewModel.validateEmail(value),
                          ),
                          SizedBox(height: 15.h),
                          CustomInputFiled(
                            label: 'Password',
                            controller:
                                loginViewModel.passwordController
                                    as TextEditingController,
                            validator:
                                (value) =>
                                    loginViewModel.validatePassword(value),
                            obscureText: true,
                          ),
                          SizedBox(height: 15.h),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => RegisterView(),
                                ),
                              );
                            },
                            child: Text('don`t have an account'),
                          ),
                          SizedBox(height: 70.h),
                          CustomButtonWidget(
                            title: 'Log In',
                            onTap: () {
                              ref
                                  .read(authViewModelProvider.notifier)
                                  .signInUserAccount(
                                    formKey,
                                    loginViewModel.emailController!.text,
                                    loginViewModel.passwordController!.text,
                                  );
                            },
                            buttonState: authState.isLoading,
                          ),
                          SizedBox(height: 40.h),
                          Text('-Or sign in with -'),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OauthButton(
                                path: 'assets/google.svg',
                                onTap: () {
                                  ref
                                      .read(authViewModelProvider.notifier)
                                      .signInUsingGoogle();
                                },
                              ),
                              OauthButton(
                                path: 'assets/facebook.svg',
                                onTap: () {
                                  ref
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
      ),
    );
  }
}
