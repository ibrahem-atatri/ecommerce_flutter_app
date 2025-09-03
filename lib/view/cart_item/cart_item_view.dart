import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/view/widget/custom_button_widget.dart';
import 'package:ecommerce_app/view/widget/custom_cart_item_tile.dart';
import 'package:ecommerce_app/view/widget/in_progress_alert.dart';
import 'package:ecommerce_app/view/widget/no_internet_connection_alert.dart';
import 'package:ecommerce_app/view/widget/no_internet_connection_widget.dart';
import 'package:ecommerce_app/view_model/cart_item_view_model.dart';
import 'package:ecommerce_app/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemView extends ConsumerStatefulWidget {
  const CartItemView({Key? key}) : super(key: key);

  @override
  _CartItemViewState createState() => _CartItemViewState();
}

class _CartItemViewState extends ConsumerState<CartItemView> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      ref.read(cartItemViewProvider.notifier).getCartItem();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverAppBar(

                          title: Text(
                            'View Cart',
                            style: TextStyle(color: Colors.orange[500]),
                          ),
                          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.orange.shade500,), onPressed: () {
                            ref.read(mainViewModelProvider.notifier).restPages();
                          },),
                        ),
                        internetState.value == true
                            ? data.length == 0
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
                                  itemCount: (data.length + 1),
                                  itemBuilder: (context, index) {
                                    if (index < data.length) {
                                      return CustomCartItemTile(index: index);
                                    } else if (ref.watch(cartItemViewProvider.notifier).hasMore == false &&
                                        ref.watch(cartItemViewProvider.notifier).isLoading == false &&
                                        index == data.length) {
                                      return Padding(
                                        padding: EdgeInsetsGeometry.symmetric(
                                          vertical: 30,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'These are all the items.',
                                          ),
                                        ),
                                      );
                                    } else if (ref.watch(cartItemViewProvider.notifier).isLoading == true &&
                                        ref.read(cartItemViewProvider.notifier,).hasMore == true && index == data.length) {
                                      return Padding(
                                        padding: EdgeInsetsGeometry.symmetric(
                                          vertical: 30,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.orange.shade500,
                                          ),
                                        ),
                                      );
                                    }

                                    // scrollController.offset < scrollController.position.viewportDimension
                                  },
                                )
                            : SliverToBoxAdapter(
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 150.h),
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
                        child:Consumer(builder: (context, ref, child) {
                          final amount = ref.watch(totalAmountProvider);
                          return amount.when(data: (data) {

                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0.h,
                                  horizontal: 8.w,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Amount'),

                                          Text(
                                          '\$${data}',
                                        ),


                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(
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
                                padding: EdgeInsets.symmetric(
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
                                      '${data}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );},error: (error, stackTrace) {
                            final message;
                            if (error is FirebaseException)
                              message = error.message ?? 'error to fetch item';
                            else
                              message = error.toString();
                            return Center(child:Text(message));
                          }, loading: () {
                            return Center(child: CircularProgressIndicator(color: Colors.orange.shade500,));
                            },);



                        },)
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
                                    ? InProgressAlert()
                                    : NoInternetConnectionAlert();
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
              return Center(child: Text('${error} ${stackTrace}'));
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
