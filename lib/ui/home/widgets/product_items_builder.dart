import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/ui/home/widgets/gridview_item_widget.dart';
import 'package:ecommerce_app/ui/item_describtion/product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItemsBuilder extends StatelessWidget {
  const ProductItemsBuilder({super.key,required this.data});
  final List<ProductModel> data;
    @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 18.w,
        childAspectRatio:
        5.w /
            9.5.h, //-------------------
      ),
      itemCount: data.length,
      itemBuilder: (
          context,
          index,
          ) {
        return GestureDetector(
          onTap:
              () => Navigator.of(
            context,
          ).push(
            MaterialPageRoute(
              builder:
                  (c,) => ProductDetailView(
                productModel:
                data[index],
              ),
            ),
          ),
          child: GridviewItemWidget(
            productModel:
            data[index],
          ),
        );
      },
    );
  }
}
