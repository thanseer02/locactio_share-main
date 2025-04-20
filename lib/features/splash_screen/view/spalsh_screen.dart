import 'package:ODMGear/common/app_styles.dart';
import 'package:ODMGear/features/home/view/home_screen.dart';
import 'package:ODMGear/features/login_screen/view/login_screen.dart';
import 'package:ODMGear/helpers/sp_helper.dart';
import 'package:ODMGear/utils/sp_keys.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashscreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      SpHelper.getString(keyToken).then((value) {
        if (value != null) {
          Navigator.of(context).pushReplacementNamed(
            HomeScreen.routeName,
          );
        } else {
          Navigator.of(context).pushReplacementNamed(
            LoginScreen.routeName,
          );
        }
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Welcome ODMgear',
              style: tsS20W600.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),
   
          Center(
            child: Text(
              'Please wait while we load the app',
              style: tsS16W500.copyWith(
                color: Colors.black,
              ),
            ),
          ),  
        ],
      ),
    );
  }




}
