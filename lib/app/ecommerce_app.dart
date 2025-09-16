import 'package:ecommerce_app/app/ecommerce_app_view_model.dart';
import 'package:ecommerce_app/app/widgets/custtom_bottom_navigation_bar.dart';
import 'package:ecommerce_app/provider/theme.dart';
import 'package:ecommerce_app/ui/login_register/log_in_register_view_model.dart';
import 'package:ecommerce_app/ui/login_register/log_in_register_view.dart';
import 'package:ecommerce_app/utils/dark_light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EcommerceApp extends ConsumerWidget {
  const EcommerceApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authStateProvider);
    final themeState = ref.watch(themesProvider);
    return ScreenUtilInit(
      designSize: Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: DarkLightTheme.lightTheme,
          darkTheme: DarkLightTheme.darkTheme,
          themeMode:themeState,
          debugShowCheckedModeBanner: false,
          title: 'Flutter ecommerce demo',
          home: userState.when(
            data: (data) {
              if (data == null) {
                return LogInRegisterView();
              } else {
                return EcommerceAppView();
              }
            },
            error: (error, stackTrace) {
              return Center(child: Text('oops, $error'));
            },
            loading:
                () => Center(
                  child: CircularProgressIndicator(color: Colors.orange[500]),
                ),
          ),
        );
      },
    );
  }
}

class EcommerceAppView extends ConsumerWidget {
  const EcommerceAppView({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(ecommerceAppViewModelProvider);

    return Scaffold(
      body: ref.read(ecommerceAppViewModelProvider.notifier).pages[currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          ref.read(ecommerceAppViewModelProvider.notifier).setCurrentPage(value);
        },
        items:  ref.read(ecommerceAppViewModelProvider.notifier).bottomNavItems.map((item) {
          return BottomNavigationBarItem(icon: item['icon'],label: item['label']);
        },).toList(),

      ),
    );
  }
}
