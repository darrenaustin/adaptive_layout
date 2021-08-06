import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adaptive_scaffold.dart';
import 'app_state.dart';
import 'breakpoint.dart';
import 'breakpoints.dart';
import 'featured_items.dart';
import 'nav_destination.dart';

void main() {
  runApp(AdaptiveApp());
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
        final double width = constraints.maxWidth;

        // I think it would be nicer to have written this as:
        // if (breakpoint.isDesktop) ...

        late final double dx;
        switch (breakpoint) {
          case DesktopSmallBreakpoint():
          case DesktopLargeBreakpoint():
            if (width < 192) {
              dx = math.max(0, (width - 96) / 2);
            } else if (width < 840) {
              dx = 48;
            } else if (width < 1240) {
              dx = (width - 840) / 2;
            } else {
              dx = 200;
            }
            break;
          default:
            dx = 0;
            break;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: dx),
          child: child,
        );
      }
    );
  }
}

class AdaptiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = const ColorScheme.light();
    final theme = ThemeData.from(colorScheme: colorScheme).copyWith(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onBackground,
      ),
    );
    return App(
      destinations: _navDestinations,
      child: MaterialApp(
        title: 'Adaptive Layout Demo',
        theme: theme,
        routes: {
          'featured': (BuildContext context) => ContentPage(title: 'Featured', content: FeaturedItems()),
          'chat': (BuildContext context) => ExamplePage(title: 'Chat'),
          'rooms': (BuildContext context) => ExamplePage(title: 'Rooms'),
          'meet': (BuildContext context) => ExamplePage(title: 'Meet'),
        },
        debugShowCheckedModeBanner: false,
        initialRoute: _navDestinations[0].route,
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
  ExamplePage({Key? key, required this.title}) : super(key: key);

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
            color: Colors.grey[300],
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
  ContentPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

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
            icon: Icon(Icons.settings),
            onPressed: () => app.showNavigation = !app.showNavigation,
          ),
        ],
      ),
      body: ResponsiveBody(child: content),
    );
  }
}

const List<NavigationDestination> _navDestinations = const <NavigationDestination>[
  NavigationDestination(label: 'Featured', icon: Icons.featured_video, route: 'featured'),
  NavigationDestination(label: 'Chat', icon: Icons.chat_bubble_outline, route: 'chat'),
  NavigationDestination(label: 'Rooms', icon: Icons.room, route: 'rooms'),
  NavigationDestination(label: 'Meet', icon: Icons.video_call_outlined, route: 'meet'),
];
