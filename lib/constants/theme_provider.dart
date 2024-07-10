import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'consts.dart';

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: kBlackColor,
      fontFamily: kFontFamilyName,
      colorScheme: const ColorScheme.dark().copyWith(
          background: kBlackColor, error: kRedColor, secondary: kPrimaryColor),
      primaryColor: kPrimaryColor,
      indicatorColor: kPrimaryColor,
      hintColor: kPrimaryColor.withOpacity(.3),
      cardColor: kLightBlackColor,
      textTheme: const TextTheme().copyWith(
        bodySmall: const TextStyle(color: kLightWhiteColor),
        displayLarge: const TextStyle(color: kLightWhiteColor),
      ),
      dialogBackgroundColor: kBlackColor,
      appBarTheme: const AppBarTheme().copyWith(color: kBlackColor),
      iconTheme: const IconThemeData().copyWith(color: kLightWhiteColor),
      bottomSheetTheme:
          const BottomSheetThemeData().copyWith(backgroundColor: kBlackColor),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kBlackColor,
      ));
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: kWhiteColor,
    dialogBackgroundColor: kWhiteColor,
    fontFamily: kFontFamilyName,
    colorScheme: const ColorScheme.light().copyWith(
        surface: kWhiteColor, error: kRedColor, secondary: kPrimaryColor),
    primaryColor: kPrimaryColor,
    indicatorColor: kPrimaryColor,
    hintColor: kPrimaryColor.withOpacity(.3),
    textTheme: const TextTheme().copyWith(
        displayLarge: const TextStyle(color: kWhiteColor),
        bodySmall: const TextStyle(color: kBlackColor),
        displaySmall: const TextStyle(color: kGrayColor)),
    iconTheme: const IconThemeData().copyWith(color: kBlackColor),
    appBarTheme: const AppBarTheme().copyWith(
      color: kWhiteColor,
      surfaceTintColor: Colors.transparent,
    ),
    cardColor: kLightGrayColor,
    bottomSheetTheme: const BottomSheetThemeData()
        .copyWith(backgroundColor: kWhiteColor, shadowColor: kWhiteColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kWhiteColor,
    ),
  );
  ThemeMode themeMode = ThemeMode.system;

  static bool isDarkMode() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode;
  }
}
