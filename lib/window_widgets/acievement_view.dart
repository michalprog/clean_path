import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/l10n/app_localizations.dart';
import '/providers/achievment_provider.dart';
import '/widgets/achivement_widget.dart';

class AchievementView extends StatelessWidget {
  const AchievementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final achievementProvider = Provider.of<AchievementProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: achievementProvider.statisticInicjalization(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return Scaffold(
            appBar: AppBar(centerTitle: true, title: Text(l10n.achievementsTitle)),
            body: Consumer<AchievementProvider>(
              builder: (context, achievementProvider, child) {
                if (achievementProvider.showAchievements.isEmpty) {
                  return Center(child: Text(l10n.noAchievements));
                } else {
                  return ListView.builder(
                    itemCount: achievementProvider.showAchievements.length,
                    itemBuilder: (context, index) {
                      final record = achievementProvider.showAchievements[index];
                      return AchievementWidget(record: record);
                    },
                  );
                }
              },
            ),
          );
        }
      },
    );

  }
}