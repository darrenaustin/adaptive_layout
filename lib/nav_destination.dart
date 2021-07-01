import 'package:flutter/material.dart';

class NavigationDestination {
  const NavigationDestination({
    required this.label,
    required this.icon,
    required this.route
  });

  final String label;
  final IconData icon;
  final String route;

  static NavigationRailDestination toRailDestination(NavigationDestination destination) {
    return NavigationRailDestination(
      label: Text(destination.label),
      icon: Icon(destination.icon),
    );
  }

  static BottomNavigationBarItem toBottomNavItem(NavigationDestination destination) {
    return BottomNavigationBarItem(
      label: destination.label,
      icon: Icon(destination.icon),
    );
  }
}
