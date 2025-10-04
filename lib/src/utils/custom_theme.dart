import 'package:flutter/material.dart';
import 'package:klontong/src/utils/const.dart';

ThemeData lightMode = ThemeData(
  fontFamily: "Poppins",
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.secondary,
    selectionColor: AppColors.secondary.withOpacity(0.1),
    selectionHandleColor: AppColors.secondary,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppColors.primary,
    circularTrackColor: AppColors.secondary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.background,
    secondary: AppColors.secondary,
    primary: AppColors.primary,
  ),
);
