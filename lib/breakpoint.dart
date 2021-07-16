import 'package:flutter/material.dart';

abstract class Breakpoint {
  const Breakpoint();
  bool isActive(BuildContext context, BoxConstraints constraints);
}

class _InheritedBreakpointLayout<T> extends InheritedWidget {
  const _InheritedBreakpointLayout({
    Key? key,
    required this.breakpoints,
    required this.constraints,
    required Widget child,
  }) : super(key: key, child: child);

  final Iterable<T> breakpoints;
  final BoxConstraints constraints;

  @override
  bool updateShouldNotify(_InheritedBreakpointLayout oldWidget) {
    return constraints != oldWidget.constraints || breakpoints != oldWidget.breakpoints;
  }
}

class BreakpointLayout<T extends Breakpoint> extends StatelessWidget {
  const BreakpointLayout({
    Key? key,
    required this.breakpoints,
    required this.child,
  }) : super(key: key);

  final Iterable<T> breakpoints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return _InheritedBreakpointLayout<T>(
            breakpoints: breakpoints,
            constraints: constraints,
            child: child,
          );
        }
    );
  }

  static T breakpointFor<T extends Breakpoint>(BuildContext context) {
    final _InheritedBreakpointLayout<T> layout = context.dependOnInheritedWidgetOfExactType<_InheritedBreakpointLayout<T>>()!;
    return layout.breakpoints.firstWhere((T breakpoint) => breakpoint.isActive(context, layout.constraints));
  }
}
