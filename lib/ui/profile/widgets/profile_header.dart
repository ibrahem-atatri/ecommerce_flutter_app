import 'package:ecommerce_app/app/ecommerce_app_view_model.dart';
import 'package:ecommerce_app/ui/profile/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.primaryColor,
          ),
          onPressed: () {
            ref.read(ecommerceAppViewModelProvider.notifier).restPages();
          },
        ),
        ThemeSwitch(),
      ],
    );
  }
}
