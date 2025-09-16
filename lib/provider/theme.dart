import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themesProvider = StateNotifierProvider<Themes, ThemeMode>(
  (ref) {
    return Themes();
  },
);

class Themes extends StateNotifier<ThemeMode> {
  final themeKey = 'theme_mode';

  Themes() : super(ThemeMode.system) {
    getThemeMode();
  }

  Future<void> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    state = ThemeMode.values[prefs.getInt(themeKey) ?? ThemeMode.system.index];
  }

  Future<void> setThemeMode(value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, value);
  }

  void toggleTheme() {
    final themeMode = state;

    if (themeMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark) {
        state = ThemeMode.light;
      } else {
        state = ThemeMode.dark;
      }
    } else {
      if (themeMode == ThemeMode.light) {
        state = ThemeMode.dark;
      } else {
        state = ThemeMode.light;
      }
      setThemeMode(state.index);
    }
  }
}
