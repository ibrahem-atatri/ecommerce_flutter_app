import 'package:ecommerce_app/app/ecommerce_app.dart';
import 'package:ecommerce_app/app/ecommerce_app_view_model.dart';
import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/ui/login_register/log_in_register_view_model.dart';
import 'package:ecommerce_app/ui/widget/button/custom_button_widget.dart';
import 'package:ecommerce_app/ui/widget/alerts/in_progress_alert.dart';
import 'package:ecommerce_app/ui/widget/internet_connectivity_widgets/no_internet_connection_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileBody extends ConsumerWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(logInRegisterViewModelProvider);
    final internetState = ref.watch(internetConnectionProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return internetState.value == true
                        ? inProgressAlert()
                        : noInternetConnectionAlert();
                  });
            },
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                border: Border.all(color: theme.primaryColor, width: 2.r),
                // image: DecorationImage(image: AssetImage('assets/img.png'),fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Icon(
                Icons.person,
                size: 80.r,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            user.value?.displayName ?? '',
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 32.r,
            ),
          ),
          Text(
            'Welcome ',
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 18.r,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: theme.colorScheme.secondary,
            thickness: 1.r,
            indent: 60.w,
            endIndent: 60.w,
            height: 10.h,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            color: theme.primaryColor.withValues(alpha: 0.7),
            elevation: 15,
            child: ListTile(
              leading: Icon(
                Icons.mail,
                size: 32.r,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                user.value!.email.toString(),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 24.r, color: theme.colorScheme.primary),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 8.h),
            child: CustomButtonWidget(
                title: 'Sign Out',
                onTap: () async {
                  ref.read(ecommerceAppViewModelProvider.notifier).restPages();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => EcommerceApp()),
                    (route) => false,
                  );
                  await ref
                      .read(logInRegisterViewModelProvider.notifier)
                      .signOutUser();
                }),
          ),
        ],
      ),
    );
  }
}
