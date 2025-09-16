import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget confirmDeleteAlert({context, onPressed}){
  return Dialog(
    child: Container(
      height: 280.h,
      width: 200.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dangerous_outlined,size: 50.r,color: Colors.orange.shade500,),
          SizedBox(height: 20.h),
          Text(
            'Are you sure to Delete Item ?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 16.r,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed:onPressed,style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange.shade500),), child: Text('Yes',style: TextStyle(color: Colors.white),)),
              ElevatedButton(onPressed: (){
                    Navigator.of(context).pop();
              }, style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey.shade400),),child: Text('Cancle',style: TextStyle(color: Colors.white),),),
            ],
          )
        ],
      ),
    ),
  );
}