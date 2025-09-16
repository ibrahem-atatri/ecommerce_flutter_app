import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, required this.onChanged});
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            cursorColor: theme.colorScheme.secondary,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search,
                  size: 40.r, color: theme.colorScheme.secondary),
              label: Text(
                'Search',
                style: TextStyle(
                  color: theme.colorScheme.primary.withAlpha(100),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.r,
                  color: theme.colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }
}
