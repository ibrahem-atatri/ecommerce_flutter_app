import 'package:ecommerce_app/app/ecommerce_app_view_model.dart';
import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/ui/cart_item/cart_item_view_model.dart';
import 'package:ecommerce_app/ui/cart_item/widgets/custom_cart_item_tile.dart';
import 'package:ecommerce_app/ui/widget/internet_connectivity_widgets/no_internet_connection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCartScrollViewWidget extends ConsumerWidget {
  const CustomCartScrollViewWidget({super.key,required this.scrollController,required this.data});
final ScrollController scrollController;
final List<CartModel> data;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final internetState = ref.watch(internetConnectionProvider);
    final theme = Theme.of(context);
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(
            'View Cart',
            style: TextStyle(color: theme.primaryColor,),
          ),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: theme.primaryColor,), onPressed: () {
            ref.read(ecommerceAppViewModelProvider.notifier).restPages();
          },),
        ),
        internetState.value == true
            ? data.isEmpty
            ? SliverToBoxAdapter(
          child: SizedBox(
            height: 200.h,
            child: Center(
              child: Text(
                'Oops, there are no items in the cart.',
                style: TextStyle(color: theme.colorScheme.secondary),
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
                    style: TextStyle(color: theme.colorScheme.primary),
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
                    color: theme.primaryColor,
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
    );
  }
}
