import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'adaptive_scaffold.dart';
import 'app_state.dart';
import 'breakpoint.dart';
import 'breakpoints.dart';
import 'featured_items.dart';
// import 'nav_destination.dart';

void main() {
  runApp(const AdaptiveApp());
}

// For the desktop breakpoints (not mobile):
// width < 192, horizontal margins = MAX(0, (width - 96) / 2)
// 192 <= width < 840, horizontal margins = 48
// 840 <= width < 1240, horizontal margins = (width - 840) / 2
// width >= 1240, horizontal margins = 200
// Based on https://carbon.googleplex.com/google-material/pages/tablet-laptop-adaptation/undefined#2d0cbc75-d041-43aa-a4ce-e5463dc1bc43
//
// The first constraint isn't given in the spec. I'm just assuming that once the body's width is
// less than the margins, the margins should get smaller (until they are 0).

class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({ Key? key, this.child }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Breakpoint breakpoint = BreakpointLayout.breakpointFor(context);
        final bool navRailShowing = AdaptiveScaffold.featuresFor(context).contains(AdaptiveScaffoldFeature.navigationRail);
        final double width = constraints.maxWidth;

        final double startMargin;
        final double endMargin;
        if (navRailShowing) {
          // I think it would be nicer to have written this as:
          // if (breakpoint.isDesktop) ...
          switch (breakpoint) {
            case DesktopSmallBreakpoint():
            case DesktopLargeBreakpoint():
              if (width < 192) {
                // Split the available space evenly for the margins.
                startMargin = math.max(0, (width - 96) / 2);
                endMargin = startMargin;
              } else if (width < (840 + 48 + 48)) {
                // Fixed margins with responsive body.
                startMargin = 48;
                endMargin = 48;
              } else if (width < (840 + 48 + 200)) {
                // Body fixed to 840, with a static 48 starting margin with the
                // rest put in the end margin.
                startMargin = 48;
                endMargin = width - 840 - startMargin;
              } else {
                // Fixed margins with responsive body.
                startMargin = 48;
                endMargin = 200;
              }
              break;
            default:
              startMargin = 0;
              endMargin = 0;
              break;
          }
        } else {
          // I think it would be nicer to have written this as:
          // if (breakpoint.isDesktop) ...
          switch (breakpoint) {
            case DesktopSmallBreakpoint():
            case DesktopLargeBreakpoint():
              if (width < 192) {
                startMargin = math.max(0, (width - 96) / 2);
              } else if (width < 840) {
                startMargin = 48;
              } else if (width < 840 + 2 * 48) {
                startMargin = 48;
              } else if (width < 1240) {
                startMargin = (width - 840) / 2;
              } else {
                startMargin = 200;
              }
              break;
            default:
              startMargin = 0;
              break;
          }
          endMargin = startMargin;
        }

        return Padding(
          // TODO(darrenaustin): handle RTL direction
          padding: EdgeInsets.only(left: startMargin, right: endMargin),
          child: child,
        );
      }
    );
  }
}

class NoPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Constructs a page transition animation that slides the page up.
  const NoPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T>? route,
      BuildContext? context,
      Animation<double> animation,
      Animation<double>? secondaryAnimation,
      Widget child,
  ) {
    return child;
  }
}

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme.light();
    final theme = ThemeData(
      colorSchemeSeed: const Color(0xff460bec),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: NoPageTransitionsBuilder(),
        },
      ),
    );
    return App(
      destinations: _navDestinations,
      child: MaterialApp(
        title: 'Adaptive Layout Demo',
        theme: theme,
        routes: {
          'Featured': (BuildContext context) => const ContentPage(title: 'Featured', content: FeaturedItems()),
          'Chat': (BuildContext context) => const ExamplePage(title: 'Chat'),
          'Rooms': (BuildContext context) => const ExamplePage(title: 'Rooms'),
          'Meet': (BuildContext context) => const ExamplePage(title: 'Meet'),
        },
        debugShowCheckedModeBanner: false,
        initialRoute: 'Featured',
        builder: (BuildContext context, Widget? child) {
          return BreakpointLayout<Breakpoint>(
            breakpoints: const <Breakpoint>[
              MobilePortraitBreakpoint(),
              DesktopSmallBreakpoint(),
              DesktopLargeBreakpoint(),
            ],
            child: child!,
          );
        },
      ),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: title,
      content: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size windowSize = MediaQuery.of(context).size;
          final double bodyWidth = constraints.biggest.width;
          return Container(
            // color: Colors.grey[300],
            decoration: BoxDecoration(
              color: Colors.grey[300], // white,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Window: ${windowSize.width.toInt()}'),
                  Text('Body: ${bodyWidth.toInt()}'),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final AppState app = App.of(context);
    return AdaptiveScaffold(
      showNavigation: app.showNavigation,
      destinations: app.destinations,
      selectedDestination: app.selectedDestination,
      onDestinationSelected: (NavigationDestination destination) {
        app.navigateTo(context, destination);
      },
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => app.showNavigation = !app.showNavigation,
          ),
        ],
      ),
      body: ResponsiveBody(child: content),
    );
  }
}

const List<NavigationDestination> _navDestinations = <NavigationDestination>[
  NavigationDestination(label: 'Featured', icon: Icon(Icons.featured_video)),
  NavigationDestination(label: 'Chat', icon: Icon(Icons.chat_bubble_outline)),
  NavigationDestination(label: 'Rooms', icon: Icon(Icons.room)),
  NavigationDestination(label: 'Meet', icon: Icon(Icons.video_call_outlined)),
];
