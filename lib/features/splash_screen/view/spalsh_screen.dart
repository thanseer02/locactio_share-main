import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routname='/splashscreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}