import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/view/cart_item/cart_item_view.dart';
import 'package:ecommerce_app/view/home/Home_view.dart';
import 'package:ecommerce_app/view/log_in/log_in_view.dart';
import 'package:ecommerce_app/view/profile/profile_view.dart';
import 'package:ecommerce_app/view/widget/customBottomNavigationBar.dart';
import 'package:ecommerce_app/view_model/auth_view_model.dart';
import 'package:ecommerce_app/view_model/main_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// cLtzv7ypYB8qrsH5XAUVHMC9Rcs=
// eKJJHinr+D3pnrXYFuIJnPbO7ag=


void main() async {
  debugPaintSizeEnabled:true;
  debugPaintPointersEnabled:true;
  debugRepaintRainbowEnabled:true;
   WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  runApp(ProviderScope(child: MyApp()));

}

///////
///TODO :you should create a different folder called app add your app class in it
///TODO : ADD NAME TO YOUR APP
class MyApp extends StatelessWidget {
  const MyApp({super.key}); //TODO : ADD const where ever it is needed to avoid no need rebuilding
  //TODO : const avoid unnecessary rebuilding to optimize your widgets
  @override
  Widget build(BuildContext context) {
   return ScreenUtilInit(designSize: Size(399, 844), //TODO: Hard-coded design size is WRONG
     minTextAdapt: true, // If the design reference (399x844) doesn’t match the actual device dimensions closely, scaling may look off.
     splitScreenMode: true,
   builder: (context, child) {
     return   MaterialApp( //try using GitMaterialApp it gives you more options
       debugShowCheckedModeBanner: false,
       title: 'Flutter ecommerce demo',
       home:  MainState(), //for best practices use splash screen ,
     ); // show the app logo and do what you want like checking if the user is logged in
   },);

  }
}

class MainState extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authStateProvider);
    return

      // userState.hasError
      //   ? Center(child: Text('oops, ${userState.error}'))
      //   : userState.isLoading
      //   ? CircularProgressIndicator(color: Colors.orange[500])
      //   : userState.value == null
      //   ? LogInView()
      //   : MainApp();

      userState.when(
      data:(data) {
        if(data == null)
          return LogInView();
        else
          return MainApp();
      },
      error: (error, stackTrace) {
        return Center(child: Text('oops, $error'),);
      },
      loading:
          () => Center(
        child: CircularProgressIndicator(color: Colors.orange[500]),
      ),
    );
  }
}

class MainApp extends ConsumerWidget {
  MainApp({super.key});
  final List<Widget> bottomNavItem = [ //move it to the view model
    HomeView(),
    CartItemView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainViewModelProvider);

    return Scaffold(
      body: bottomNavItem[currentIndex],
      bottomNavigationBar: Custombottomnavigationbar( //send the list of pages to it , don't build it internally
        currentIndex: currentIndex,
        onTap: (value) {
          ref.read(mainViewModelProvider.notifier).setCurrentPage(value);
        },
      ),
    );
  }
}
