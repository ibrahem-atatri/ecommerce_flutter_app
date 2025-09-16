import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/ui/item_describtion/widgets/color_widget.dart';
import 'package:ecommerce_app/ui/item_describtion/widgets/headline_text.dart';
import 'package:ecommerce_app/ui/item_describtion/widgets/product_cart_action.dart';
import 'package:ecommerce_app/ui/item_describtion/widgets/product_detail_header.dart';
import 'package:ecommerce_app/ui/item_describtion/widgets/product_size.dart';
import 'package:ecommerce_app/ui/item_describtion/widgets/product_title_rating_price_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            ProductDetailHeader(imagePath: productModel.image),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 1.sw * 0.08,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitleRatingPriceTile(productModel: productModel),
                  SizedBox(height: 14.h),
                  headlineText(
                      text: 'Details', color: theme.colorScheme.primary),
                  SizedBox(height: 10.h),
                  Text(
                    productModel.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  headlineText(text: 'Color', color: theme.colorScheme.primary),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      ColorWidget(color: Colors.black),
                      SizedBox(width: 10.w),
                      ColorWidget(color: Color(0xffF29D38)),
                      SizedBox(width: 10.w),
                      ColorWidget(color: Color(0xff1B71D7)),
                      SizedBox(width: 10.w),
                      ColorWidget(color: Color(0xffFF650E)),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  headlineText(text: 'Size', color: theme.colorScheme.primary),
                  SizedBox(height: 10.h),
                  ProductSize(),
                  SizedBox(height: 14.h),
                  ProductCartAction(productModel: productModel),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
