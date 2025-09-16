import 'package:ecommerce_app/ui/home/home_view_model.dart';
import 'package:ecommerce_app/ui/home/widgets/swiper_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySwiper extends ConsumerWidget {
  const CategorySwiper({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return  SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection:
        Axis.horizontal,
        itemCount:
        ref
            .read(
          homeViewModelProvider
              .notifier,
        )
            .getCategory()
            .length,
        itemBuilder: (
            context,
            index,
            ) {
          final category =
          ref
              .read(
            homeViewModelProvider
                .notifier,
          )
              .getCategory();
          return SwiperItemWidget(
            category: category[index],
            onTap: () {
              ref
                  .read(
                homeViewModelProvider
                    .notifier,
              )
                  .filtterByCategory(
                category[index]
                    .categoryName,
              );
            },
          );
        },
      ),
    );
  }
}
