import 'package:base_project/common/app_colors.dart';
import 'package:flutter/material.dart';

/// Light Theme Object
final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
  ),
  textTheme: const TextTheme(),
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: AppColors.colorWhite),
  useMaterial3: false,
);

/// Dark Theme Object
final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
  ),
  textTheme: const TextTheme(),
  useMaterial3: false,
);
