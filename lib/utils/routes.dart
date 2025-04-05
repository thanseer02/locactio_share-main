import 'package:base_project/features/map_screen/map_screen.dart';
import 'package:base_project/features/splash_screen/view/spalsh_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> appRoutes() => {
      SplashScreen.routeName: (context) => const SplashScreen(),
      MapScreen.routeName: (context) => const MapScreen(),
};
Widget? _getScreen(RouteSettings settings) {
  switch (settings.name) {
    default:
      return null;
  }
}

RouteFactory onAppGenerateRoute() => (settings) {
      Widget? screen = _getScreen(settings);
      if (screen != null) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (_, a, __, c) {
            return FadeTransition(opacity: a, child: c);
          },
        );
      }
      return null;
    };
