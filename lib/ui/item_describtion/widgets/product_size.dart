import 'package:ecommerce_app/ui/widget/alerts/in_progress_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSize extends StatelessWidget {
  const ProductSize({super.key});
  final int value = 38;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownMenu(
      onSelected: (value) {
        showDialog(context: context, builder:
            (context) => inProgressAlert(),);
      },
      label: Text(
        'CHOOSE SIZE',
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontSize: 12.sp,
        ),
      ),
      width: 1.sw / 2,
      trailingIcon: Icon(
        Icons.arrow_forward_ios,
        size: 24.r,
        color: theme.colorScheme.secondary,
      ),
      dropdownMenuEntries: [
        DropdownMenuEntry(value: value, label: '38'),
      ],
    );
  }
}
