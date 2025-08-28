import 'package:ecommerce_app/view/widget/in_progress_alert.dart';
import 'package:flutter/material.dart';

class ColorWidget extends StatelessWidget {
   const ColorWidget({super.key ,required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (context) => InProgressAlert(),);
      },
      child: Container(
        width: 35,
        height: 35,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Colors.black.withOpacity(0.8)),
          color: Colors.white,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}



