import 'package:ecommerce_app/view/item_describtion/item_description_view.dart';
import 'package:ecommerce_app/view/widget/custom_circular_button.dart';
import 'package:ecommerce_app/view_model/cart_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomCartItemTile extends ConsumerWidget {
  const CustomCartItemTile({super.key,required this.index});
final int index;
  void onGestureTap(context,productModel){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemDescriptionView(productModel:productModel),));
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final items = ref.watch(cartItemViewProvider);
    final item = items.value?[index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 80.h,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  onGestureTap(context, item?.productModel);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  width: 75.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: AspectRatio(
                    aspectRatio: 10.r / 9.r,
                    child: Image.network(item?.productModel.image??'https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png?20210521171500'),
                  ),
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Row(
                  // spacing: (MediaQuery.of(context).size.width - 90 )/ 3.25,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                              onGestureTap(context, item?.productModel);
                        },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width:ScreenUtil().screenWidth*0.45,
                            child: Text(
                              item?.productModel.title??'',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          Text(
                            item?.productModel.category??'',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            '\$${item?.productModel.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0,
                          ),
                          // alignment: Alignment.topRight,
                          onPressed: () {
                            ref.read(cartItemViewProvider.notifier).deleteFromCart(item!.productModel.id.toString());
                          },
                          enableFeedback: !items.isLoading,
                          icon:items.isLoading? CircularProgressIndicator() : SvgPicture.asset(
                            alignment: Alignment.topRight,
                            'assets/trash.svg',
                            color: Colors.orange[500],
                            height: 22.h,
                            width: 22.w,
                          ),
                        ),
                        Row(
                          children: [
                            CustomCircularButton(text: '-',onTap: () {
                              ref.read(cartItemViewProvider.notifier).decrementCartItem(item!);
                            },),
                            SizedBox(width: 10.w),
                            Text(
                              item?.quantity.toString()??'',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10.w),
                            CustomCircularButton(text: '+',onTap: () {
                              ref.read(cartItemViewProvider.notifier).incrementCartItem(item!);
                            },),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 25.w),
      ],
    );
  }
}



