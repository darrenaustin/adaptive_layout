import 'package:flutter/material.dart';

import 'breakpoint.dart';

class MobilePortraitBreakpoint extends Breakpoint {
  const MobilePortraitBreakpoint();

  @override bool isActive(BuildContext context, BoxConstraints constraints) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
        return MediaQuery.of(context).orientation == Orientation.portrait;
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }
}

class DesktopSmallBreakpoint extends Breakpoint {
  const DesktopSmallBreakpoint();

  @override bool isActive(BuildContext context, BoxConstraints constraints) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
        return false;
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return constraints.biggest.width < 1024;
    }
  }
}

class DesktopLargeBreakpoint extends Breakpoint {
  const DesktopLargeBreakpoint();

  @override bool isActive(BuildContext context, BoxConstraints constraints) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
        return false;
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return constraints.biggest.width >= 1024;
    }
  }
}
