import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/view/widget/custom_button_widget.dart';
import 'package:ecommerce_app/view/widget/in_progress_alert.dart';
import 'package:ecommerce_app/view/widget/no_internet_connection_alert.dart';
import 'package:ecommerce_app/view_model/auth_view_model.dart';
import 'package:ecommerce_app/view_model/main_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user = ref.watch(authViewModelProvider);
    final internetState = ref.watch(internetConnectionProvider);
    ref.listen(authViewModelProvider, (previous, next) {
      next.when(
          data: (data){
          },
      error: (error,_){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('${ error is FirebaseAuthException ? (error.message ?? 'error in log out'): error.toString()}')));
      }, loading: () {

      });});
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(icon: Icon(Icons.arrow_back,color: Colors.orange.shade500,), onPressed: () {
            ref.read(mainViewModelProvider.notifier).restPages();
          },),
          Spacer(
            flex: 1,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder:(context){return internetState.value == true ?InProgressAlert():NoInternetConnectionAlert();});
                  },
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade500,
                      border: Border.all(color: Colors.orange.shade500,width: 2.r),
                      // image: DecorationImage(image: AssetImage('assets/img.png'),fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(Icons.person,size: 80.r,color: Colors.white,),
                  ),
                ),

                Text(
                  user.value?.displayName??'',
                  style: TextStyle(
                    color: Color(0xFF6C8090),
                    fontSize: 32.r,
                    // fontFamily: 'Pacifico',
                  ),
                ),
                Text(
                  'Welcome ',
                  style: TextStyle(
                    color: Colors.orange[500],
                    fontSize: 18.r,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  color: Color(0xFF6C8090),
                  thickness: 1.r,
                  indent: 60.w,
                  endIndent: 60.w,
                  height: 10.h,
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  color: Colors.orange.withValues(alpha: 0.4),
                  elevation: 15,
                  shadowColor: Colors.black.withValues(alpha: 0.6),
                  child: ListTile(
                    leading: Icon(
                      Icons.mail,
                      size: 32.r,
                      color: Color(0xFF2B475E),
                    ),
                    title: Text(
                      user.value!.email.toString(),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 24.r),
                    ),
                  ),
                ),

                Padding(
                  padding:EdgeInsetsGeometry.symmetric(horizontal: 16.w,vertical: 8.h),
                  child: CustomButtonWidget(title: 'Sign Out', onTap: ()async{
                    ref.read(mainViewModelProvider.notifier).restPages();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context) => MainState()), (route) => false,);
                    await ref.read(authViewModelProvider.notifier).signOutUser();
                  }),
                ),

              ],
            ),
          ),
          Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}
