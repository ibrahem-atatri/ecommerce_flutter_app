import 'package:dio/dio.dart';
import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/utils/greeting_based_time.dart';
import 'package:ecommerce_app/view/item_describtion/item_description_view.dart';
import 'package:ecommerce_app/view/widget/gridview_item_widget.dart';
import 'package:ecommerce_app/view/widget/search_bar_widget.dart';
import 'package:ecommerce_app/view/widget/swiper_item_widget.dart';
import 'package:ecommerce_app/view_model/auth_view_model.dart';
import 'package:ecommerce_app/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final getGreeting = GreetingBasedTime.getGreeting();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 30.w, left: 30.w, top: 40.h),

          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(right: 0, left: 20.w),
                title: Consumer(
                  builder: (context, ref, child) {
                    return Text(
                      'Hi ${ref.watch(authViewModelProvider).value?.displayName?.split(' ').first}',
                      style: TextStyle(
                        fontSize: 14.r,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                subtitle: Text(
                  '$getGreeting!',
                  style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.w800),
                ),
                trailing: CircleAvatar(
                  radius: 30.r,
                  // backgroundImage: AssetImage('assets/img.png'),
                  backgroundColor: Colors.orange.shade500,
                  child: Icon(Icons.person, size: 40.r, color: Colors.white),
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final internetState = ref.watch(internetConnectionProvider);
                    final products = ref.watch(homeViewModelProvider);
                    ref.listen(internetConnectionProvider, (previous, next) {
                      next.when(data: (data) {
                        if(!data)
                        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('no internet connection'),duration: Duration(seconds: 1),));
                      }, error: (error, stackTrace) {
                        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                      }, loading: () {

                      },);
                    },);
                    return Column(
                      children: [
                        SearchBarWidget(
                          onChanged: (value) {
                            ref
                                .read(homeViewModelProvider.notifier)
                                .searchAboutProduct(value);
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: internetState.when(
                              data: (state) {
                                return state
                                    ? products.when(
                                      data: (data) {
                                        if (data != null || data.length > 0) {
                                          return Column(
                                            children: [
                                              Container(
                                                height: 40.h,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      ref
                                                          .read(
                                                            homeViewModelProvider
                                                                .notifier,
                                                          )
                                                          .getCategory()
                                                          .length,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    final category =
                                                        ref
                                                            .read(
                                                              homeViewModelProvider
                                                                  .notifier,
                                                            )
                                                            .getCategory();
                                                    return SwiperItemWidget(
                                                      category: category[index],
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                              homeViewModelProvider
                                                                  .notifier,
                                                            )
                                                            .filtterByCategory(
                                                              category[index]
                                                                  .categoryName,
                                                            );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 30.h),
                                              Expanded(
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing: 10.h,
                                                        crossAxisSpacing: 18.w,
                                                        childAspectRatio:
                                                            5.w /
                                                            9.5.h, //-------------------
                                                      ),
                                                  itemCount: data.length,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    return GestureDetector(
                                                      onTap:
                                                          () => Navigator.of(
                                                            context,
                                                          ).push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    c,
                                                                  ) => ItemDescriptionView(
                                                                    productModel:
                                                                        data[index],
                                                                  ),
                                                            ),
                                                          ),
                                                      child: GridviewItemWidget(
                                                        productModel:
                                                            data[index],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: Text('oops, no Data found'),
                                          );
                                        }
                                      },
                                      error: (error, stackTrace) {
                                        String message;
                                        if (error is DioException)
                                          message =
                                              error.message.toString() ??
                                              'there are an error to fetch data';
                                        else
                                          message = error.toString();
                                        print(' $message');
                                        return Text('error $error');
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${error.toString()}')));
                                      },
                                      loading: () {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.orange[500],
                                          ),
                                        );
                                      },
                                    )
                                    : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/no_internet.svg',
                                            width: 200,
                                            height: 200,
                                            color: Colors.orange,
                                          ),
                                          Text(
                                            'No Internet Connection',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                              },
                              error: (error, stackTrace) {},
                              loading: () {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.orange[500],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
