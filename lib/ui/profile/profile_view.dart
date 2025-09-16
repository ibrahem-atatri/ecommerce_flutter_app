import 'package:ecommerce_app/ui/profile/widgets/profile_body.dart';
import 'package:ecommerce_app/ui/profile/widgets/profile_header.dart';
import 'package:ecommerce_app/ui/widget/error_widgets/error_alert.dart';
import 'package:ecommerce_app/ui/widget/error_widgets/error_widget.dart';
import 'package:ecommerce_app/ui/login_register/log_in_register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const String pageLabel = 'Profile';
  static const Icon pageIcon = Icon(
    Icons.person,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = Theme.of(context);
        ref.listen(logInRegisterViewModelProvider, (previous, next) {
          next.when(
              data: (data) {},
              error: (error, _) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return errorAlert(
                        message: error.toString(),
                        mainColor: theme.colorScheme.primary);
                  },
                );
              },
              loading: () {});
        });
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(),
              Spacer(
                flex: 1,
              ),
              ProfileBody(),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
