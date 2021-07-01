import 'package:flutter/widgets.dart';

abstract class Breakpoint {
  const Breakpoint();

  Object get name;
  bool isActive(BuildContext context);

  @override
  String toString() {
    return 'Breakpoint $name';
  }
}

class Breakpoints<T extends Breakpoint> extends InheritedWidget {
  Breakpoints({
    Key? key,
    required this.breakpoints,
    required Widget child,
  }) : assert(breakpoints.isNotEmpty),
       super(key: key, child: child);

  final Iterable<T> breakpoints;

  @override
  bool updateShouldNotify(Breakpoints oldWidget) => breakpoints != oldWidget.breakpoints;

  static T breakpointFor<T extends Breakpoint>(BuildContext context) {
    final Breakpoints<T> layout = context.dependOnInheritedWidgetOfExactType<Breakpoints<T>>()!;
    return layout.breakpoints.firstWhere((T breakpoint) => breakpoint.isActive(context), orElse: () => layout.breakpoints.last);
  }
}
