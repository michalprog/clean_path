import 'package:flutter/material.dart';

import '/main/service_locator.dart';
import '/providers/settings_storage.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  MaterialColor _accentColor = Colors.green;
  double _textScale = 1.0;
  Locale _locale = const Locale('en');
  final SettingsStorage _storage = getIt<SettingsStorage>();

  SettingsProvider() {
    _loadSavedLocale();
  }

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

  Future<void> updateLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    await _storage.saveLocale(locale);
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = await _storage.loadLocale();
    if (savedLocale == null || savedLocale == _locale) return;

    _locale = savedLocale;
    notifyListeners();
  }
}