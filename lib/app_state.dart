import 'package:flutter/material.dart';

class App extends StatefulWidget {

  const App({
    Key? key,
    required this.destinations,
    required this.child,
  }) : super(key: key);

  final List<NavigationDestination> destinations;
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
  late NavigationDestination _selectedDestination;

  bool get showNavigation => _showNavigation;
  set showNavigation(bool navigation) => setState(() => _showNavigation = navigation);

  List<NavigationDestination> get destinations => widget.destinations;

  NavigationDestination get selectedDestination => _selectedDestination;
  void navigateTo(BuildContext context, NavigationDestination destination) {
    _selectedDestination = destination;
    Navigator.of(context).pushNamed(destination.label);
  }

  @override
  void initState() {
    super.initState();
    _selectedDestination = destinations.first;
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
