import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartAmountWidget extends StatelessWidget {
  const CartAmountWidget({super.key,required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              Text('Total Amount',style: TextStyle(color: theme.colorScheme.primary),),

              Text('\$$data',style: TextStyle(color: theme.colorScheme.primary)),
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
            children: [
              Text('Discount',style: TextStyle(color: theme.colorScheme.primary)),
              Text('\$0.0',style: TextStyle(color: theme.colorScheme.primary)),
            ],
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
                  color: theme.colorScheme.primary
                ),
              ),
              Text(
                data,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
