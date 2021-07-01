import 'package:flutter/widgets.dart';

class BreakpointLayout {
  BreakpointLayout(this.value, this.builder);

  final double value;
  final LayoutWidgetBuilder builder;
}

class BreakpointLayoutBuilder extends StatelessWidget {
  BreakpointLayoutBuilder({
    Key? key,
    required this.breakpoints,
  }) : assert(breakpoints.length > 0),
       assert(
         _areBreakpointsSorted(breakpoints),
         'Breakpoints list must be sorted by increasing breakpoint value'
       ),
       super(key: key);

  final List<BreakpointLayout> breakpoints;

  LayoutWidgetBuilder _closestLayout(double width) {
    int current = 0;
    while (current < breakpoints.length) {
      if (width <= breakpoints[current].value) {
        return breakpoints[current].builder;
      }
      current++;
    }
    return breakpoints.last.builder;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      LayoutWidgetBuilder layout = _closestLayout(constraints.maxWidth);
      return layout(context, constraints);
    });
  }
}

bool _areBreakpointsSorted(List<BreakpointLayout> breakpoints) {
  for (int i = 1; i < breakpoints.length; i++) {
    if (breakpoints[i - 1].value >= breakpoints[i].value) {
      return false;
    }
  }
  return true;
}
