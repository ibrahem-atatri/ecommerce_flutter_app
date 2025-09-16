import 'package:ecommerce_app/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductTitleRatingPriceTile extends StatelessWidget {
  const ProductTitleRatingPriceTile({super.key,required this.productModel});

  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  ListTile(
      contentPadding: EdgeInsets.all(0),
      title: SizedBox(
        width: 1.sw,
        child: Text(
          productModel.title,
          softWrap: true,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      subtitle: Padding(
        padding: EdgeInsets.only(
          top: 10.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 35.r,
                  color: theme.primaryColor,
                ),
                Text(
                  '${productModel.rating.rate} (${productModel.rating.count} Review)',
                  style: TextStyle(color:theme.primaryColor),
                ),
              ],
            ),

            Text(
              '\$${productModel.price}',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
