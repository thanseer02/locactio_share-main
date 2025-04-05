import 'package:base_project/features/splash_screen/view/spalsh_screen.dart';
import 'package:base_project/services/interceptors.dart';
import 'package:base_project/utils/extensions.dart';
import 'package:base_project/utils/routes.dart';
import 'package:base_project/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Location Share',
          navigatorKey: AppUtils.navKey,
          initialRoute: SplashScreen.routeName,
          onGenerateRoute: onAppGenerateRoute(),
          routes: appRoutes(),
          builder: (context, child) {
            AppUtils.initContext = context;

            if (kDebugMode) {
              StackTrace.current
                  .toString()
                  .log('@${StackTrace.current.runtimeType}');
              child = AppStackInterceptorBuilder(child: child!);
            }
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            );
          },
        );
      },
    );
  }
}
