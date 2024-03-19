import 'package:flutter/material.dart';

class ThemeHelper {
  static Color primaryColor = const Color(0xFF3C6FD1);
}

class Themes {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      accentColor: ThemeHelper.primaryColor,
    ),
    scaffoldBackgroundColor: ThemeHelper.primaryColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ThemeHelper.primaryColor,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    dividerColor: Colors.white,
    dividerTheme: const DividerThemeData(color: Colors.white),
    fontFamily: 'Poppins',
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );
}
