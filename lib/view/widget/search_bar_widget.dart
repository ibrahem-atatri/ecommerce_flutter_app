import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends StatelessWidget {
   const SearchBarWidget({super.key,required this.onChanged});
final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(

            onChanged: onChanged,
            cursorColor: Colors.black.withOpacity(0.5),
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search, size: 40.r, color: Colors.grey),
              label: Text(
                'Search',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.r,
                  color: Colors.black.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        // Container(
        //   padding: EdgeInsets.all(4.r),
        //   decoration: BoxDecoration(
        //     color: Colors.black,
        //     borderRadius: BorderRadius.circular(5.r),
        //   ),
        //   child: Icon(Icons.search, size: 40.r, color: Colors.white),
        // ),
      ],
    );
  }
}
