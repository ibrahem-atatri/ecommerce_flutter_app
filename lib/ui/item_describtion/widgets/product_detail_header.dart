import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailHeader extends StatelessWidget {
   const ProductDetailHeader({super.key,required this.imagePath});
   final String imagePath;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // width: 365,
      height:340.h ,
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        // color: Colors.grey.withOpacity(0.2),
        // color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          topLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(5.r),
          bottomLeft: Radius.circular(5.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {Navigator.of(context).pop();},
                icon: Icon(Icons.arrow_back,color: theme.colorScheme.primary,),
              ),


            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Image.network(
            height:
            1.sh / 4,
            // 220.h,
            // MediaQuery.of(context).size.height / 4,
            width:  1.sw/1.8,            // 250.w,
            // MediaQuery.of(context).size.width/1.8,
            alignment: Alignment.center,
            imagePath,

          ),
        ],
      ),
      // ),
    );
  }
}
