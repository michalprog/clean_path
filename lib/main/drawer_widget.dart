import 'package:flutter/material.dart';

import '/l10n/app_localizations.dart';
import '/window_widgets/settings_view.dart';
import '/statistc_views/main_Statistic.dart';
import '/window_widgets/acievement_view.dart';

class DrawerWidget extends StatelessWidget {
  final int index;
  const DrawerWidget({super.key, required this.index,});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF3B5E3B), // ciemnozielony/oliwkowy
            ),
            child: Text(
              l10n.drawerOptions,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text(l10n.drawerStatistics),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainStatistic(index: index,)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(l10n.languageSectionTitle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.forum),
            title: Text(l10n.drawerForum),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text(l10n.drawerAchievements),
            onTap:  () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AchievementView()),
              );
            },
          ),
        ],
      ),
    );
  }

}