import 'package:flutter/material.dart';

import 'breakpoint.dart';
import 'breakpoints.dart';
import 'nav_destination.dart';

class AdaptiveScaffold extends StatefulWidget {
  const AdaptiveScaffold({
    Key? key,
    this.showNavigation = true,
    required this.destinations,
    required this.selectedDestination,
    required this.onDestinationSelected,
    required this.appBar,
    required this.body,
  }) : super(key: key);

  final bool showNavigation;
  final List<NavigationDestination> destinations;
  final NavigationDestination selectedDestination;
  final ValueChanged<NavigationDestination> onDestinationSelected;
  final PreferredSizeWidget appBar;
  final Widget body;

  @override
  _AdaptiveScaffoldState createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> with SingleTickerProviderStateMixin {

  Widget _buildWithNav(BuildContext context) {
    late bool showNavRail;
    final Breakpoint breakpoint = BreakpointLayout.breakpointFor(context);
    switch (breakpoint) {
      case DesktopSmallBreakpoint():
        showNavRail = false;
        break;
      case DesktopLargeBreakpoint():
        showNavRail = true;
        break;
    }

    final double railWidth = 72;
    final double bottomNavHeight = kBottomNavigationBarHeight;
    final int selectedIndex = widget.destinations.indexOf(widget.selectedDestination);

    return Scaffold(
      appBar: widget.appBar,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: showNavRail ? railWidth : 0,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.centerRight,
                minWidth: railWidth,
                maxWidth: railWidth,
                child: NavigationRail(
                  destinations: widget.destinations.map(NavigationDestination.toRailDestination).toList(),
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (int index) {
                    widget.onDestinationSelected(widget.destinations[index]);
                  },
                ),
              ),
            ),
          ),
          Expanded(child: widget.body),
        ],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: showNavRail ? 0 : bottomNavHeight,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.topCenter,
            minHeight: bottomNavHeight,
            maxHeight: bottomNavHeight,
            child: BottomNavigationBar(
              items: widget.destinations.map(NavigationDestination.toBottomNavItem).toList(),
              currentIndex: selectedIndex,
              showUnselectedLabels: true,
              onTap: (int index) {
                widget.onDestinationSelected(widget.destinations[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWithoutNav(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: widget.body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.showNavigation
      ? _buildWithNav(context)
      : _buildWithoutNav(context);
  }
}
