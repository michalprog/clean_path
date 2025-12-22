import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('pl'),
    const Locale('es'),
    const Locale('de'),
  ];
  static String getFlag(String code) {
    switch (code) {
      case 'pl':
        return 'pl';
      case 'es':
        return '🇪🇸';
      case 'de':
        return '🇩🇪';
      case 'en':
      default:
        return 'en';
    }
  }
}
