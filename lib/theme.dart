import 'package:flutter/material.dart';

class AppThemeConstants {
  static final Color primaryColor = Colors.blue.shade900;
  static const Color secondaryColor = Colors.blueAccent;
  static const Color bodyTextColor = Colors.white;
  static const Color warningColor = Colors.red;
  static final Color fieldColor = Colors.grey.shade200;
  static const Color hintColor = Colors.grey;
  static const Radius mainBorderRadius = Radius.circular(30.0);
  static const Radius fieldBorderRadius = Radius.circular(10.0);
  static const double bodyFontSize = 16.0;
}

final ThemeData appThemeData = ThemeData(
  primaryColor: AppThemeConstants.primaryColor,
  colorScheme: ColorScheme.light(
    primary: AppThemeConstants.primaryColor,
    secondary: AppThemeConstants.secondaryColor
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.resolveWith<TextStyle?>((_) => 
        const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold
        )
      ),
      padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>((_) => 
        const EdgeInsets.all(18.0)
      ),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((_) => 
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(AppThemeConstants.mainBorderRadius)
        )
      )
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppThemeConstants.fieldColor,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 8.0, 
      horizontal: 16.0
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(AppThemeConstants.fieldBorderRadius),
      borderSide: BorderSide.none,
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(AppThemeConstants.fieldBorderRadius),
      borderSide: BorderSide(
        color: AppThemeConstants.warningColor
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(AppThemeConstants.fieldBorderRadius),
      borderSide: BorderSide(
        color: AppThemeConstants.warningColor
      ),
    ),
    errorStyle: const TextStyle(
      color: AppThemeConstants.warningColor
    ),
    hintStyle: const TextStyle(
      color: AppThemeConstants.hintColor
    )
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppThemeConstants.secondaryColor
  )
);
