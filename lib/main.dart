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
            color: Colors.white,
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
      body: content,
    );
  }
}

const List<NavigationDestination> _navDestinations = const <NavigationDestination>[
  NavigationDestination(label: 'Featured', icon: Icons.featured_video, route: 'featured'),
  NavigationDestination(label: 'Chat', icon: Icons.chat_bubble_outline, route: 'chat'),
  NavigationDestination(label: 'Rooms', icon: Icons.room, route: 'rooms'),
  NavigationDestination(label: 'Meet', icon: Icons.video_call_outlined, route: 'meet'),
];
