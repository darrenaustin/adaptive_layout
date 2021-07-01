import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../nav_destination.dart';
import 'breakpoint_layout.dart';

enum _NavigationUIType { bottomBar, rail_extended, rail }

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    Key? key,
    this.navigationDestinations,
    this.selectedDestination = 0,
    this.onDestinationSelected,
    this.appBar,
    this.body,
  }) : super(key: key);

  final List<NavigationDestination>? navigationDestinations;
  final int selectedDestination;
  final ValueChanged<int>? onDestinationSelected;
  final PreferredSizeWidget? appBar;
  final Widget? body;

  Widget _scaffold(double leftPadding, double rightPadding, [_NavigationUIType? navType]) {
    final bool navRail =
      navigationDestinations != null &&
      (navType == _NavigationUIType.rail || navType == _NavigationUIType.rail_extended);
    final bool navRailExtended = navRail && navType == _NavigationUIType.rail_extended;
    final bool navBottomBar =
      navigationDestinations != null &&
      navType == _NavigationUIType.bottomBar;

    return Scaffold(
      appBar: this.appBar,
      body: Row(
        children: [
          if (navRail)
            NavigationRail(
              destinations: navigationDestinations!.map(NavigationDestination.toRailDestination).toList(),
              selectedIndex: selectedDestination,
              onDestinationSelected: onDestinationSelected,
              extended: navRailExtended,
              labelType: navRailExtended ? null : NavigationRailLabelType.all,
            ),
          Expanded(
            child: Container(
              // color: Colors.grey.withOpacity(0.50),
              padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
              child: body,
            ),
          ),
        ],
      ),
      bottomNavigationBar: navBottomBar
        ? BottomNavigationBar(
            items: navigationDestinations!.map(NavigationDestination.toBottomNavItem).toList(),
            currentIndex: selectedDestination,
            onTap: onDestinationSelected,
          )
        : null,
    );
  }

  LayoutWidgetBuilder _bodyFixedWidth(double bodyWidth, [_NavigationUIType? navType]) {
    return (BuildContext context, BoxConstraints constraints) {
      final double padding = math.max((constraints.maxWidth - bodyWidth) / 2, 0);
      if (navType == _NavigationUIType.rail_extended) {
        double leftPadding = 48;
        double rightPadding = constraints.maxWidth - (48 + bodyWidth);
        return _scaffold(leftPadding, rightPadding, navType);
      }
      return _scaffold(padding, padding, navType);
    };
  }

  LayoutWidgetBuilder _paddingFixedWidth(double paddingLeft, double paddingRight, [_NavigationUIType? navType]) {
    return (BuildContext context, BoxConstraints constraints) {
      return _scaffold(paddingLeft, paddingRight, navType);
    };
  }

  Widget _buildWithNav(BuildContext context) {
    return BreakpointLayoutBuilder(
      breakpoints: <BreakpointLayout>[
        BreakpointLayout(48 + 640 + 48, _bodyFixedWidth(640, _NavigationUIType.bottomBar)),
        BreakpointLayout(48 + 840 + 48, _paddingFixedWidth(48, 48, _NavigationUIType.rail)),
        BreakpointLayout(48 + 840 + 200, _bodyFixedWidth(840, _NavigationUIType.rail_extended)),
        BreakpointLayout(double.infinity, _paddingFixedWidth(48, 200, _NavigationUIType.rail_extended)),
      ],
    );
  }

  Widget _buildWithoutNav(BuildContext context) {
    return BreakpointLayoutBuilder(
      breakpoints: <BreakpointLayout>[
        BreakpointLayout(48 + 640 + 48, _bodyFixedWidth(640)),
        BreakpointLayout(48 + 840 + 48, _paddingFixedWidth(48, 48)),
        BreakpointLayout(200 + 840 + 200, _bodyFixedWidth(840)),
        BreakpointLayout(double.infinity, _paddingFixedWidth(200, 200)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return navigationDestinations != null
      ? _buildWithNav(context)
      : _buildWithoutNav(context);
  }
}
