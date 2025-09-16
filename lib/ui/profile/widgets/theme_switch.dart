import 'package:ecommerce_app/provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    bool switchValue = ref.watch(themesProvider).name == 'system'
        ? (theme.brightness.name == 'dark' ? true : false)
        : ref.watch(themesProvider).name == 'dark'
            ? true
            : false;
    return Switch(
        padding: EdgeInsets.only(left: 20, top: 20),
        value: switchValue,
        activeThumbImage: Svg(
          'assets/dark_mode_icon.svg',
        ),
        activeTrackColor: Colors.white,
        activeThumbColor: Colors.orange.shade500,
        inactiveThumbImage: Svg(
          'assets/light_mode_icon.svg',
        ),
        inactiveTrackColor: Colors.orange.shade500,
        inactiveThumbColor: Colors.white,
        trackOutlineColor: WidgetStatePropertyAll(Colors.orange.shade500),
        onChanged: (value) {
          switchValue = value;
          ref.read(themesProvider.notifier).toggleTheme();
        });
  }
}
