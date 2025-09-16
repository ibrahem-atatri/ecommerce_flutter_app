import 'package:ecommerce_app/app/ecommerce_app.dart';
import 'package:ecommerce_app/ui/login_register/log_in/log_in_view.dart';
import 'package:ecommerce_app/ui/login_register/register/register_view.dart';
import 'package:ecommerce_app/ui/widget/button/custom_button_widget.dart';
import 'package:ecommerce_app/ui/login_register/widgets/oauth_button.dart';
import 'package:ecommerce_app/ui/login_register/log_in_register_view_model.dart';
import 'package:ecommerce_app/ui/widget/error_widgets/error_alert.dart';
import 'package:ecommerce_app/ui/widget/error_widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogInRegisterView extends StatefulWidget {
  const LogInRegisterView({super.key});

  @override
  State<LogInRegisterView> createState() => _LogInRegisterViewState();
}

class _LogInRegisterViewState extends State<LogInRegisterView> {
  bool hasAccount = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(logInRegisterViewModelProvider);
        final authNotifier = ref.read(logInRegisterViewModelProvider.notifier);
        ref.listen(logInRegisterViewModelProvider, (previous, next) {
          next.when(
            data: (data) {
              if (data != null) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => EcommerceApp()),
                  (route) => false,
                );
              }
            },
            error: (error, stackTrace) {
              showDialog(
                context: context,
                builder: (context) {
                  return errorAlert(message: error.toString(),mainColor: Theme.of(context).colorScheme.primary);
                },
              );
            },
            loading: () {},
          );
        });
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 30.h),
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
                        alignment: Alignment.topLeft,
                        child: Text(
                          hasAccount
                              ? 'Login to Your Account'
                              : 'Create Your Account',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Form(
                        key: formKey,
                        child:
                            hasAccount
                                ? LogInView(
                                  emailController: emailController,
                                  passwordController: passwordController,
                                )
                                : RegisterView(
                                  userNameController: userNameController,
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  confirmPasswordController:
                                      confirmPasswordController,
                                ),
                      ),
                      SizedBox(height: 15.h),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              hasAccount = !hasAccount;
                            });
                          },
                          child: Text(
                            hasAccount
                                ? 'don`t have an account'
                                : 'I have an account',
                          ),
                        ),
                      ),
                      SizedBox(height: 60.h),
                      CustomButtonWidget(
                        title: hasAccount ? 'Log In' : 'Register',
                        onTap: () {
                          if(!formKey.currentState!.validate()) return;
                          hasAccount
                              ? authNotifier.signInUserAccount(
                                email: emailController.text,
                                password: passwordController.text,
                              )
                              : authNotifier.register(
                                email: emailController.text,
                                password: passwordController.text,
                                name: userNameController.text,
                              );
                        },
                        buttonState: authState.isLoading,
                      ),

                      SizedBox(height: 40.h),
                      Text(
                        hasAccount ? 'Or Log In with' : '-Or sign up with -',
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OauthButton(
                            path: 'assets/google.svg',
                            onTap: () async {
                              await authNotifier.signInUsingGoogle();
                            },
                          ),
                          OauthButton(
                            path: 'assets/facebook.svg',
                            onTap: () async {
                              await authNotifier.signInUsingFacebook();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
