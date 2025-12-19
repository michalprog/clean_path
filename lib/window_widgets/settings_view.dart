import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const List<Locale> _languageOptions = [
    Locale('pl'),
    Locale('en'),
    Locale('es'),
    Locale('de'),
  ];

  static const Map<String, String> _languageNames = {
    'pl': 'Polski',
    'en': 'English',
    'es': 'Español',
    'de': 'Deutsch',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Language',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('App language'),
                          subtitle:
                          const Text('Select your preferred language'),
                          trailing: DropdownButton<Locale>(
                            value: provider.locale,
                            underline: const SizedBox.shrink(),
                            items: _languageOptions
                                .map(
                                  (locale) => DropdownMenuItem<Locale>(
                                value: locale,
                                child: Text(_languageLabel(locale)),
                              ),
                            )
                                .toList(),
                            onChanged: (locale) {
                              if (locale != null) {
                                provider.updateLocale(locale);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _languageLabel(Locale locale) {
    return _languageNames[locale.languageCode] ??
        locale.languageCode.toUpperCase();
  }
}
