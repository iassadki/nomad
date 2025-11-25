import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final BuildContext context;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.context,
  }) : super(key: key);

  void _navigateTo(int index) {
    onTap(index);
    String routeName = '';
    switch (index) {
      case 0:
        routeName = '/trips';
        break;
      case 1:
        routeName = '/search';
        break;
      case 2:
        routeName = '/favorites';
        break;
      case 3:
        routeName = '/profile';
        break;
    }
    
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: _navigateTo,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFFF8D2E),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      iconSize: 28,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.plane),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.heart),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              label: 'Profile',
            ),
          ],
        );
  }
}
