import 'package:flutter/material.dart';
import '/main/service_locator.dart';
import '/providers/settings_storage.dart';

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  final SettingsStorage _storage = getIt<SettingsStorage>();

  SettingsProvider() {
    _loadSavedLocale();
  }

  Locale get locale => _locale;

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
