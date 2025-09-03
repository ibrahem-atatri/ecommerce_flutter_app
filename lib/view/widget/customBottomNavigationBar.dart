import 'package:flutter/material.dart';

class Custombottomnavigationbar extends StatelessWidget {
   Custombottomnavigationbar({super.key,required this.currentIndex,required this.onTap});
int currentIndex;
final onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(color: Colors.grey[300], height: 2),
        BottomNavigationBar(
          // type: BottomNavigationBarType.shifting,
          enableFeedback: false,
          elevation: 0,
          useLegacyColorScheme: false,
          selectedFontSize: 15,
          unselectedFontSize: 15,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap:  onTap,
          selectedItemColor: Colors.orange,
          selectedIconTheme: IconThemeData(color: Colors.orange),
          unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ],
    );
  }

}
