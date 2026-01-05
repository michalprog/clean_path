import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../widgets/language_tile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const List<({Locale locale, String name, String flag})>
  _languageOptions = [
    (locale: Locale('pl'), name: 'Polski', flag: '🇵🇱'),
    (locale: Locale('en'), name: 'English', flag: '🇬🇧'),
    (locale: Locale('es'), name: 'Español', flag: '🇪🇸'),
    (locale: Locale('de'), name: 'Deutsch', flag: '🇩🇪'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Text(l10n.languageSectionTitle),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                    for (final option in _languageOptions) ...[
                      LanguageTile(
                        name: option.name,
                        flag: option.flag,
                        locale: option.locale,
                        isSelected: provider.locale == option.locale,
                        selectedLabel: l10n.selectedLanguageLabel,
                        onTap: () => provider.updateLocale(option.locale),
                      ),
                      if (option != _languageOptions.last)
                        const SizedBox(height: 12),
                    ],
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
