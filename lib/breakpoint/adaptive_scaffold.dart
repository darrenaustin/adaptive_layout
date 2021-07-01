import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../nav_destination.dart';
import 'breakpoint.dart';

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
    assert(leftPadding >= 0);
    assert(rightPadding >= 0);
    final bool navRail =
      navigationDestinations != null &&
      (navType == _NavigationUIType.rail || navType == _NavigationUIType.rail_extended);
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
              extended: navType == _NavigationUIType.rail_extended,
            ),
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.50),
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
    return Breakpoints<WidthBreakpointLayout>(
      breakpoints: [
        WidthBreakpointLayout(48 + 840 + 200, _paddingFixedWidth(48, 200, _NavigationUIType.rail_extended)),
        WidthBreakpointLayout(48 + 840 + 48, _bodyFixedWidth(840, _NavigationUIType.rail_extended)),
        WidthBreakpointLayout(48 + 640 + 48, _paddingFixedWidth(48, 48, _NavigationUIType.rail)),
        WidthBreakpointLayout(0, _bodyFixedWidth(640, _NavigationUIType.bottomBar)),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final WidthBreakpointLayout breakpoint = Breakpoints.breakpointFor<WidthBreakpointLayout>(context);
          return LayoutBuilder(builder: breakpoint.layoutBuilder);
        }
      ),
    );
  }

  Widget _buildWithoutNav(BuildContext context) {
    return Breakpoints<WidthBreakpointLayout>(
      breakpoints: [
        WidthBreakpointLayout(48 + 840 + 200, _paddingFixedWidth(200, 200)),
        WidthBreakpointLayout(48 + 840 + 48, _bodyFixedWidth(840)),
        WidthBreakpointLayout(48 + 640 + 48, _paddingFixedWidth(48, 48)),
        WidthBreakpointLayout(0, _bodyFixedWidth(640)),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final WidthBreakpointLayout breakpoint = Breakpoints.breakpointFor<WidthBreakpointLayout>(context);
          return LayoutBuilder(builder: breakpoint.layoutBuilder);
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return navigationDestinations != null
      ? _buildWithNav(context)
      : _buildWithoutNav(context);
  }
}

class WidthBreakpointLayout extends Breakpoint {
  const WidthBreakpointLayout(this.width, this.layoutBuilder);

  final double width;
  final LayoutWidgetBuilder layoutBuilder;

  @override
  bool isActive(BuildContext context) {
    return MediaQuery.of(context).size.width >= width;
  }

  @override
  Object get name => 'Width: $width';
}
