import 'package:ODMGear/features/map_screen/view_model.dart/map_view_model.dart';
import 'package:ODMGear/common/app_theme.dart';
import 'package:ODMGear/features/splash_screen/view/spalsh_screen.dart';
import 'package:ODMGear/firebase_options.dart';
import 'package:ODMGear/helpers/firebase_helper.dart';
import 'package:ODMGear/services/interceptors.dart';
import 'package:ODMGear/utils/extensions.dart';
import 'package:ODMGear/utils/routes.dart';
import 'package:ODMGear/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initFirebase();
  runApp(const MyApp());
}

Future<void> initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(
      FirebaseMessagingHelper.firebaseMessagingBackgroundHandler,
    );
    await _setUpFireBase();
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _setUpFireBase() async {
  try {
    await FirebaseMessagingHelper().setUpFirebase();
  } catch (ex) {
    debugPrint(ex.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MapViewModel(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ODMGear',
            navigatorKey: AppUtils.navKey,
            theme: lightTheme,
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
      ),
    );
  }
}
