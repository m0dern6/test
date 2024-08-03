import 'package:flutter/material.dart';
import 'package:portfolio/theme/dark_theme.dart';
import 'package:portfolio/theme/light_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeMode = lightTheme;

  ThemeData get themeData => _themeMode;

  set themeData(ThemeData themeData) {
    _themeMode = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == lightTheme) {
      themeData = darkTheme;
    } else {
      themeData = lightTheme;
    }
  }
}
