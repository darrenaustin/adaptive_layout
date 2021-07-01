import 'package:flutter/material.dart';

import 'nav_destination.dart';

class App extends StatefulWidget {

  const App({
    Key? key,
    required this.destinations,
    this.initialDestination = 0,
    required this.child,
  }) : super(key: key);

  final List<NavigationDestination> destinations;
  final int initialDestination;
  final Widget child;

  static AppState of(BuildContext context) {
    final _InheritedAppState state = context.dependOnInheritedWidgetOfExactType<_InheritedAppState>()!;
    return state.data;
  }

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {

  bool _showNavigation = true;
  int _currentDestinationIndex = 0;

  bool get showNavigation => _showNavigation;
  set showNavigation(bool navigation) {
    setState(() {
      _showNavigation = navigation;
    });
  }

  int get currentDestinationIndex => _currentDestinationIndex;
  set currentDestinationIndex(int index) {
    setState(() {
      _currentDestinationIndex = index;
    });
  }

  void navigateTo(BuildContext context, int destinationIndex) {
    currentDestinationIndex = destinationIndex;
    Navigator.of(context).pushNamed(widget.destinations[_currentDestinationIndex].route);
  }

  @override
  void initState() {
    super.initState();
    _currentDestinationIndex = widget.initialDestination;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedAppState(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedAppState extends InheritedWidget {

  const _InheritedAppState({required this.data, required Widget child}) : super(child: child);

  final AppState data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
