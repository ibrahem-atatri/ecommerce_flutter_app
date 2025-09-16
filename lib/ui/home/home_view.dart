import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/ui/home/widgets/category_swiper.dart';
import 'package:ecommerce_app/ui/home/widgets/home_view_header.dart';
import 'package:ecommerce_app/ui/home/widgets/product_items_builder.dart';
import 'package:ecommerce_app/ui/home/widgets/search_bar_widget.dart';
import 'package:ecommerce_app/ui/widget/error_widgets/error_widget.dart';
import 'package:ecommerce_app/ui/widget/internet_connectivity_widgets/no_internet_connection_widget.dart';
import 'package:ecommerce_app/ui/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const  String pageLabel = 'Home';
  static const Icon pageIcon =  Icon(Icons.home,);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 30.w, left: 30.w, top: 40.h),

          child: Column(
            children: [
                      HomeViewHeader(),

              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final internetState = ref.watch(internetConnectionProvider);
                    final products = ref.watch(homeViewModelProvider);
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
                                        if ( data.isNotEmpty) {
                                          return Column(
                                            children: [
                                                CategorySwiper(),
                                              SizedBox(height: 30.h),
                                              Expanded(
                                                child:  ProductItemsBuilder(data: data),
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

                                        return Center(child: errorWidget(message: error.toString(),mainColor: theme.colorScheme.primary.withValues(alpha: 0.1)));
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${error.toString()}')));
                                      },
                                      loading: () {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: theme.primaryColor,
                                          ),
                                        );
                                      },
                                    )
                                    : Center(
                                      child:NoInternetConnectionWidget()
                                    );
                              },
                              error: (error, stackTrace) {
                                return Center(child: errorWidget(message: error.toString(),mainColor: theme.colorScheme.primary.withValues(alpha: 0.1)));
                              },
                              loading: () {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: theme.primaryColor,
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
