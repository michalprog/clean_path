import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/enums/enums.dart';

class SettingsStorage {
  SettingsStorage(this._preferences);

  final SharedPreferences _preferences;

  static const _localeKey = 'locale';
  static const _timerRewardedDaysPrefix = 'timer_rewarded_days_';
  static const _timerStartPrefix = 'timer_start_';

  Future<Locale?> loadLocale() async {
    final code = _preferences.getString(_localeKey);
    if (code == null || code.isEmpty) return null;

    return Locale(code);
  }

  Future<void> saveLocale(Locale locale) async {
    await _preferences.setString(_localeKey, locale.languageCode);
  }

  Future<int> loadTimerRewardedDays(AddictionTypes type) async {
    return _preferences.getInt('$_timerRewardedDaysPrefix${type.index}') ?? 0;
  }

  Future<void> saveTimerRewardedDays(AddictionTypes type, int days) async {
    await _preferences.setInt('$_timerRewardedDaysPrefix${type.index}', days);
  }

  Future<String?> loadTimerStart(AddictionTypes type) async {
    return _preferences.getString('$_timerStartPrefix${type.index}');
  }

  Future<void> saveTimerStart(AddictionTypes type, DateTime start) async {
    await _preferences.setString(
      '$_timerStartPrefix${type.index}',
      start.toIso8601String(),
    );
  }

  Future<void> clearTimerProgress(AddictionTypes type) async {
    await _preferences.remove('$_timerRewardedDaysPrefix${type.index}');
    await _preferences.remove('$_timerStartPrefix${type.index}');
  }
}