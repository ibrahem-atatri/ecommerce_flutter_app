import 'package:ecommerce_app/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridviewItemWidget extends StatelessWidget {
   GridviewItemWidget({super.key,required this.productModel});
  ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 8.h),
          height: 200.h,
          width:ScreenUtil().screenWidth - 10.w /2.w,
          decoration: BoxDecoration(
            color: Color(0xffD3D3D3).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Image.network(
            productModel.image,
            // scale: 1.8,
            alignment: AlignmentDirectional.center,
            fit: BoxFit.contain,

          ),
        ),
        Padding(
          padding:  EdgeInsets.only(left: 15.w, top: 10.h),
          child: Text(
            productModel.title,
            style: TextStyle(color: Colors.grey[700]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0.w),
          child: Text(
            '\$${productModel.price}',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
