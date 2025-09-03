import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/view/widget/color_widget.dart';
import 'package:ecommerce_app/view/widget/confirm_delete_alert.dart';
import 'package:ecommerce_app/view/widget/custom_button_widget.dart';
import 'package:ecommerce_app/view/widget/header_text.dart';
import 'package:ecommerce_app/view/widget/in_progress_alert.dart';
import 'package:ecommerce_app/view_model/item_description_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/custom_circular_button.dart';

class ItemDescriptionView extends StatelessWidget {
  ItemDescriptionView({super.key,required this.productModel});
  final ProductModel productModel;
  int value = 38;
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              double screenHieght = constraints.maxHeight;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // AspectRatio(
                      // aspectRatio: 10.r/9.r,
                      // child:
                Container(
                  // width: 365,
                        height:340.h ,
                        margin: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffDDD5E5).withValues(alpha: 0.8),
                          // color: Colors.grey.withOpacity(0.2),
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
                                  icon: Icon(Icons.arrow_back),
                                ),


                              ],
                            ),
                            SizedBox(
                              // height:screenHieght*0.07 ,
                              height: 20.h,
                            ),
                            Image.network(
                              height:
                                  ScreenUtil().screenHeight / 4,
                              // 220.h,
                              // MediaQuery.of(context).size.height / 4,
                              width: ScreenUtil().screenWidth /1.8,
                              // 250.w,
                              // MediaQuery.of(context).size.width/1.8,
                              alignment: Alignment.center,
                              productModel.image,

                            ),
                          ],
                        ),
                      // ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().screenWidth * 0.08,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Container(
                              width: screenWidth,
                              child: Text(
                                productModel.title,
                                softWrap: true,
                                style: TextStyle(
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
                                        color: Color(0xffF29D38),
                                      ),
                                      Text(
                                        '${productModel.rating.rate} (${productModel.rating.count} Review)',
                                        style: TextStyle(color: Color(0xffF29D38)),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    '\$${productModel.price}',
                                    style: TextStyle(
                                      color: Color(0xffF29D38),
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          HeaderText(screenWidth: screenWidth, text: 'Details'),
                          SizedBox(height:10.h),
                          Text(
                            productModel.description,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          HeaderText(screenWidth: screenWidth, text: 'Color'),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              ColorWidget(color: Colors.black),
                              SizedBox(width: 10.w),
                              ColorWidget(color: Color(0xffF29D38)),
                              SizedBox(width: 10.w),
                              ColorWidget(color: Color(0xff1B71D7)),
                              SizedBox(width: 10.w),
                              ColorWidget(color: Color(0xffFF650E)),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          HeaderText(text: 'Size', screenWidth: screenWidth),
                          SizedBox(height: 10.h),
                          DropdownMenu(
                            onSelected: (value) {
                              showDialog(context: context, builder:
                              (context) => InProgressAlert(),);
                            },
                            label: Text(
                              'CHOOSE SIZE',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                            width: ScreenUtil().screenWidth / 2,
                            trailingIcon: Icon(
                              Icons.arrow_forward_ios,
                              size: 24.r,
                              color: Colors.grey,
                            ),
                            dropdownMenuEntries: [
                              DropdownMenuEntry(value: value, label: '38'),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Consumer(
                            builder: (context, ref, child) {
                              final item = ref.watch(itemDescriptionProvider(productModel));
                              return item.when(

                                data: (data) {
                                  return data != null ? Row(

                                      mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Quantity',style: TextStyle(color: Colors.orange[500],fontSize: 18.sp,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 50.w,),
                                        CustomCircularButton(text: '-',onTap: () {
                                  if(data?.quantity ==1){
                                  showDialog(context: context, builder: (context) {
                                  return ConfirmDeleteAlert(context: context,onPressed: (){
                                  ref.read(itemDescriptionProvider(productModel).notifier).deleteFromCart(itemId: productModel.id.toString());
                                  Navigator.of(context).pop();
                                  });
                                  },);}else{
                                          ref.read(itemDescriptionProvider(productModel).notifier).decrementQuantity(itemId: productModel.id.toString());}
                                        },),
                                        SizedBox(width: 10.w),
                                        Text(
                                          data.quantity.toString()??'',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 10.w),
                                        CustomCircularButton(text: '+',onTap: () {
                                          ref.read(itemDescriptionProvider(productModel).notifier).incrementQuantity(itemId: productModel.id.toString());
                                        },),


                                    ],
                                  ) :

                                    CustomButtonWidget(
                                    onTap: () => ref.read(itemDescriptionProvider(productModel).notifier).addToCart(prductModel: productModel),
                                    title:  'Add To Cart'
                                  );

                                }, error: (error, stackTrace) {

                                  final message;
                                  if(error is FirebaseException)
                                    message = error.message??'There is an error in the cart ';
                                  else
                                    message = error.toString();

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)),
                                    );
                                  });
                                return Center(child: Text('${error.toString()} ${stackTrace}'),);
                              }, loading: () {
                                return Center(child: CircularProgressIndicator(color: Colors.orange[500],padding: EdgeInsets.all(5),));
                              },

                              );
                            },

                          ),

                          SizedBox(height: 20.h,),

                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

    );
  }
}

