import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/ui/cart_item/widgets/cart_amount_widget.dart';
import 'package:ecommerce_app/ui/cart_item/widgets/custom_cart_scroll_view_widget.dart';
import 'package:ecommerce_app/ui/widget/button/custom_button_widget.dart';
import 'package:ecommerce_app/ui/cart_item/cart_item_view_model.dart';
import 'package:ecommerce_app/ui/widget/error_widgets/error_widget.dart';
import 'package:ecommerce_app/ui/widget/alerts/in_progress_alert.dart';
import 'package:ecommerce_app/ui/widget/internet_connectivity_widgets/no_internet_connection_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemView extends ConsumerWidget {
  const CartItemView({super.key});
  static const  String pageLabel = 'Cart';
  static const Icon pageIcon =  Icon(Icons.shopping_cart,);
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);
    final cartItem = ref.watch(cartItemViewProvider);
    final internetState = ref.watch(internetConnectionProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0.w),
          child: cartItem.when(
            data: (data) {
              return Column(
                children: [
                  Expanded(
                    child: CustomCartScrollViewWidget(
                      scrollController: ref.read(cartItemViewProvider.notifier).scrollController,
                      data: data,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.3),

                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final amount = ref.watch(totalAmountProvider);
                            return amount.when(
                              data: (data) {
                                return CartAmountWidget(data: data);
                              },
                              error: (error, stackTrace) {
                                return Center(
                                  child: errorWidget(
                                    message: error.toString(),
                                    mainColor: theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                );
                              },
                              loading: () {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: theme.primaryColor,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0.h),
                        child: CustomButtonWidget(
                          title: 'Buy Now',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return internetState.value == true
                                    ? inProgressAlert()
                                    : noInternetConnectionAlert();
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
              return Center(
                child: errorWidget(
                  message: error.toString(),
                  mainColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
              );
            },
            loading: () {
              return Center(
                child: CircularProgressIndicator(color: theme.primaryColor),
              );
            },
          ),
        ),
      ),
    );
  }
}
