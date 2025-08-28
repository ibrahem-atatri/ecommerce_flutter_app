import 'package:ecommerce_app/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwiperItemWidget extends StatelessWidget {
   SwiperItemWidget({super.key,required this.category,required this.onTap,});
  CategoryModel category;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
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
            color: Colors.black.withOpacity(0.3),
          ),
          color: category.clicked  ? Colors.black : Colors.white,
        ),
        child: Center(
          child: Text(
            category.categoryName,
            style: TextStyle(
              color:
              category.clicked
                  ? Colors.white
                  : Colors.black.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }
}
