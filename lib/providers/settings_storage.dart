import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
SettingsStorage(this._preferences);

final SharedPreferences _preferences;

static const _localeKey = 'locale';

Future<Locale?> loadLocale() async {
final code = _preferences.getString(_localeKey);
if (code == null || code.isEmpty) return null;

return Locale(code);
}

Future<void> saveLocale(Locale locale) async {
await _preferences.setString(_localeKey, locale.languageCode);
}
}
