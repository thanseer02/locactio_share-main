import 'package:base_project/features/map_screen/map_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routname='/splashscreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, MapScreen.routname);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}