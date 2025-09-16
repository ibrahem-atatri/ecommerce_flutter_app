import 'package:ecommerce_app/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwiperItemWidget extends StatelessWidget {
    const SwiperItemWidget({super.key,required this.category,required this.onTap,});
  final CategoryModel category;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        // width: 80,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.grey,
          ),
          color: category.clicked  ? Colors.black : theme.colorScheme.secondary.withValues(alpha: 0.2),),


        child: Center(
          child: Text(
            category.categoryName,
            style: TextStyle(
              color:
              category.clicked
                  ? Colors.white.withValues(alpha: 0.9)
                  : theme.colorScheme.secondary.withValues(alpha: 0.9),
            ),
          ),
        ),
      ),
    );
  }
}
