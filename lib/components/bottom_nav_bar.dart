import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  String _getPageName(int index) {
    switch (index) {
      case 0:
        return 'Trips';
      case 1:
        return 'Search';
      case 2:
        return 'Favorites';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            _getPageName(currentIndex),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
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
        ),
      ],
    );
  }
}
