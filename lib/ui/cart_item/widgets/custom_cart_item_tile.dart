import 'package:ecommerce_app/ui/item_describtion/product_detail_view.dart';
import 'package:ecommerce_app/ui/widget/alerts/confirm_delete_alert.dart';
import 'package:ecommerce_app/ui/widget/button/custom_circular_button.dart';
import 'package:ecommerce_app/ui/cart_item/cart_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomCartItemTile extends ConsumerWidget {
  const CustomCartItemTile({super.key,required this.index});
final int index;
  void onGestureTap(context,productModel){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailView(productModel:productModel),));
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);
    final items = ref.watch(cartItemViewProvider);
    final item = items.value?[index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
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
                    color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: 10.r / 9.r,
                    child: Image.network(item?.productModel.image??'https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png?20210521171500'),
                  ),
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
                          SizedBox(
                            width:ScreenUtil().screenWidth*0.45,
                            child: Text(
                              item?.productModel.title??'',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          Text(
                            item?.productModel.category??'',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            '\$${item?.productModel.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary.withValues(alpha: 0.9),
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
                            showDialog(context: context, builder: (context) {
                              return confirmDeleteAlert(context: context,onPressed: (){
                                ref.read(cartItemViewProvider.notifier).deleteFromCart(item!);
                                Navigator.of(context).pop();
                              });
                          },);

                              }
                          ,
                          enableFeedback: !items.isLoading,
                          icon:items.isLoading? CircularProgressIndicator(color: theme.primaryColor,) : SvgPicture.asset(
                            alignment: Alignment.topRight,
                            'assets/trash.svg',
                              colorFilter: ColorFilter.mode(theme.primaryColor,BlendMode.srcIn),
                            height: 22.h,
                            width: 22.w,
                          ),
                        ),
                        Row(
                          children: [
                            CustomCircularButton(text: '-',onTap: () {
                                  if(item?.quantity ==1){
                              showDialog(context: context, builder: (context) {
                                return confirmDeleteAlert(context: context,onPressed: (){
                                  ref.read(cartItemViewProvider.notifier).deleteFromCart(item!);
                                  Navigator.of(context).pop();
                                });
                              },);}else{ref.read(cartItemViewProvider.notifier).decrementCartItem(item!);}

                            },),
                            SizedBox(width: 10.w),
                            Text(
                              item?.quantity.toString()??'',
                              style: TextStyle(fontWeight: FontWeight.bold,color: theme.colorScheme.primary),
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
        Divider(height: 25.w,color: theme.colorScheme.primary.withValues(alpha: 0.5),),
      ],
    );
  }
}



