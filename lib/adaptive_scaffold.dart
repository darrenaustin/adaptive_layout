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

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {

  @override
  void didUpdateWidget(AdaptiveScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showNavigation != widget.showNavigation) {
      setState(() {
      });
    }
  }

  Widget _buildWithNav(BuildContext context) {
    BottomNavigationBar? bottomNavigationBar;
    NavigationRail? navigationRail;

    final Breakpoint breakpoint = BreakpointLayout.breakpointFor(context);
    final int selectedIndex = widget.destinations.indexOf(widget.selectedDestination);
    switch (breakpoint) {
      case DesktopSmallBreakpoint():
        bottomNavigationBar = BottomNavigationBar(
            items: widget.destinations.map(NavigationDestination.toBottomNavItem).toList(),
            currentIndex: selectedIndex,
            onTap: (int index) {
              widget.onDestinationSelected(widget.destinations[index]);
            }
        );
        break;
      case DesktopLargeBreakpoint():
        navigationRail = NavigationRail(
          destinations: widget.destinations.map(NavigationDestination.toRailDestination).toList(),
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            widget.onDestinationSelected(widget.destinations[index]);
          },
        );
        break;
    }

    return Scaffold(
      appBar: widget.appBar,
      body: Row(
        children: [
          if (navigationRail != null) navigationRail,
          Expanded(child: widget.body),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
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
