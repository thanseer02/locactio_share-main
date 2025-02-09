import 'package:flutter/material.dart';

TextTheme _textTheme = const TextTheme();

ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'OpenSans',
  textTheme: _textTheme,
  hoverColor: Colors.transparent,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  useMaterial3: false
);
