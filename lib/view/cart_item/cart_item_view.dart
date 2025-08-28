
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/view/widget/custom_button_widget.dart';
import 'package:ecommerce_app/view/widget/custom_cart_item_tile.dart';
import 'package:ecommerce_app/view/widget/in_progress_alert.dart';
import 'package:ecommerce_app/view/widget/no_internet_connection_alert.dart';
import 'package:ecommerce_app/view/widget/no_internet_connection_widget.dart';
import 'package:ecommerce_app/view_model/cart_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemView extends ConsumerWidget {
  const CartItemView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItem = ref.watch(cartItemViewProvider);
    final internetState = ref.watch(internetConnectionProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 18.0.w),
          child: cartItem.when(
            data: (data) {
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          title: Text(
                            'View Cart',
                            style: TextStyle(color: Colors.orange[500]),
                          ),
                        ),
                          internetState.value == true?
                        data.length == 0
                            ? SliverToBoxAdapter(
                              child: Container(
                                height: 200.h,
                                child: Center(
                                  child: Text(
                                    'Oops, there are no items in the cart.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            )
                            : SliverList.builder(
                              itemCount: data.length,
                              itemBuilder:
                                  (context, index) =>
                                      CustomCartItemTile(index: index),
                            ) : SliverToBoxAdapter(
                              child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 150.h,),
                                  NoInternetConnectionWidget(),
                                ],
                              ),
                                                        ),
                            ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),

                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                vertical: 8.0.h,
                                horizontal: 8.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Amount'),
                                  Text(
                                    '\$${ref.read(cartItemViewProvider.notifier).totalAmount()}',
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding:  EdgeInsets.symmetric(
                                vertical: 8.0.h,
                                horizontal: 8.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text('Discount'), Text('\$0.0')],
                              ),
                            ),

                            Divider(),
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                vertical: 10.0.h,
                                horizontal: 8.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Grand Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${ref.read(cartItemViewProvider.notifier).totalAmount()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(bottom: 8.0.h),
                        child: CustomButtonWidget(
                          title: 'Buy Now',
                          onTap: () {

                            showDialog(
                              context: context,
                              builder: (context) {
                                return internetState == true ?InProgressAlert():NoInternetConnectionAlert();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              final message;
              if (error is FirebaseException)
                message = error.message ?? 'error to fetch item';
              else
                message = error.toString();
              return Center(child: Text('${error}'));
            },
            loading: () {
              return Center(
                child: CircularProgressIndicator(color: Colors.orange[500]),
              );
            },
          ),
        ),
      ),
    );
  }
}
