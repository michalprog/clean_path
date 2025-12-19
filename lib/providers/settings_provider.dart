import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  MaterialColor _accentColor = Colors.green;
  double _textScale = 1.0;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  MaterialColor get accentColor => _accentColor;
  double get textScale => _textScale;
  Locale get locale => _locale;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void updateAccentColor(MaterialColor color) {
    _accentColor = color;
    notifyListeners();
  }

  void updateTextScale(double scale) {
    _textScale = scale.clamp(0.8, 1.4);
    notifyListeners();
  }

  void updateLocale(Locale locale) {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();
  }
}