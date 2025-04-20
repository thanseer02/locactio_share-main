import 'package:ODMGear/features/home/view/home_screen.dart';
import 'package:ODMGear/features/login_screen/view/login_screen.dart';
import 'package:ODMGear/features/splash_screen/view/spalsh_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> appRoutes() => {
      SplashScreen.routeName: (context) => const SplashScreen(),
      LoginScreen.routeName: (context) => LoginScreen(),
      HomeScreen.routeName: (context) => HomeScreen(),
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
