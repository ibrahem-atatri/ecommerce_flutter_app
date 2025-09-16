import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(color: theme.colorScheme.secondary.withValues(alpha: 0.85), height: 2),
        BottomNavigationBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          // type: BottomNavigationBarType.shifting,
          enableFeedback: false,
          elevation: 0,
          useLegacyColorScheme: false,
          selectedFontSize: 15,
          unselectedFontSize: 15,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: theme.primaryColor,
          selectedIconTheme: IconThemeData(color:theme.primaryColor ),
          unselectedIconTheme: IconThemeData(color: theme.colorScheme.secondary.withValues(alpha: 0.85),),
          unselectedItemColor: theme.colorScheme.secondary.withValues(alpha: 0.85),
          showUnselectedLabels: true,
          items: items,
        ),
      ],
    );
  }
}
