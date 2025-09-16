import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/ui/item_describtion/product_detail_view_model.dart';
import 'package:ecommerce_app/ui/widget/alerts/confirm_delete_alert.dart';
import 'package:ecommerce_app/ui/widget/button/custom_button_widget.dart';
import 'package:ecommerce_app/ui/widget/button/custom_circular_button.dart';
import 'package:ecommerce_app/ui/widget/error_widgets/error_alert.dart';
import 'package:ecommerce_app/ui/widget/error_widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCartAction extends StatelessWidget {
  const ProductCartAction({super.key,required this.productModel});
final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer(
      builder: (context, ref, child) {
        final item = ref.watch(productDetailProvider(productModel));
        ref.listen(productDetailProvider(productModel),(previous, next) {
          if(next.hasError) {
 showDialog(context: context, builder: (context) {
   return errorAlert(message: next.error.toString(), mainColor: theme.colorScheme.primary);
 },)  ;
            }
          },);
        return
               item.isLoading? Center(child: CircularProgressIndicator(color: Colors.orange[500],padding: EdgeInsets.all(5),)) :  item.value != null ? Row(

              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Quantity',style: TextStyle(color: theme.primaryColor,fontSize: 18.sp,fontWeight: FontWeight.bold),),
                SizedBox(width: 50.w,),
                CustomCircularButton(text: '-',onTap: () {
                  if(item.value!.quantity ==1){
                    showDialog(context: context, builder: (context) {
                      return confirmDeleteAlert(context: context,onPressed: (){
                        ref.read(productDetailProvider(productModel).notifier).deleteFromCart(itemId: productModel.id.toString());
                        Navigator.of(context).pop();
                      });
                    },);}else{
                    ref.read(productDetailProvider(productModel).notifier).decrementQuantity(itemId: productModel.id.toString());}
                },),
                SizedBox(width: 10.w),
                Text(
                  item.value!.quantity.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold,color: theme.colorScheme.primary),
                ),
                SizedBox(width: 10.w),
                CustomCircularButton(text: '+',onTap: () {
                  ref.read(productDetailProvider(productModel).notifier).incrementQuantity(itemId: productModel.id.toString());
                },),


              ],
            ) :

            CustomButtonWidget(
                onTap: () => ref.read(productDetailProvider(productModel).notifier).addToCart(prductModel: productModel),
                title:  'Add To Cart'
            );






      },

    );
  }
}
