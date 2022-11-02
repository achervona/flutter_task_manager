import 'package:flutter/material.dart';

class AppConstants {
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
  primaryColor: AppConstants.primaryColor,
  colorScheme: ColorScheme.light(
    primary: AppConstants.primaryColor,
    secondary: AppConstants.secondaryColor
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
          borderRadius: BorderRadius.all(AppConstants.mainBorderRadius)
        )
      )
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppConstants.fieldColor,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 8.0, 
      horizontal: 16.0
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(AppConstants.fieldBorderRadius),
      borderSide: BorderSide.none,
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(AppConstants.fieldBorderRadius),
      borderSide: BorderSide(
        color: AppConstants.warningColor
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(AppConstants.fieldBorderRadius),
      borderSide: BorderSide(
        color: AppConstants.warningColor
      ),
    ),
    errorStyle: const TextStyle(
      color: AppConstants.warningColor
    ),
    hintStyle: const TextStyle(
      color: AppConstants.hintColor
    )
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppConstants.secondaryColor
  )
);
