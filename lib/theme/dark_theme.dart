import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff191919),
  ),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xff191919),
    primary: Color(0xffCCCCCC),
    secondary: Color(0xffA7A7A7),
  ),
);
