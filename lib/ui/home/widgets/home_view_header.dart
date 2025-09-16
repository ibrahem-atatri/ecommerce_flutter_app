import 'package:ecommerce_app/app/ecommerce_app_view_model.dart';
import 'package:ecommerce_app/ui/login_register/log_in_register_view_model.dart';
import 'package:ecommerce_app/utils/greeting_based_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeViewHeader extends StatelessWidget {
  const HomeViewHeader({super.key});
// final getGreeting =;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
        contentPadding: EdgeInsets.only(right: 0, left: 20.w),
        title: Consumer(
          builder: (context, ref, child) {
            return Text(
              'Hi ${ref.watch(logInRegisterViewModelProvider).value?.displayName?.split(' ').first}',
              style: TextStyle(
                fontSize: 14.r,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary
              ),
            );
          },
        ),
        subtitle: Text(
          '${GreetingBasedTime.getGreeting()}!',
          style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.w800,color: theme.colorScheme.primary),
        ),
        trailing: Consumer(builder: (context, ref, child) {

          return   GestureDetector(
              child: CircleAvatar(
                radius: 30.r,
                // backgroundImage: AssetImage('assets/img.png'),
                backgroundColor: theme.primaryColor,
                child: Icon(Icons.person, size: 40.r, color: Colors.white),
              ),
              onTap: (){
                ref.read(ecommerceAppViewModelProvider.notifier).goTo(2);
              });


        },));
  }
}
