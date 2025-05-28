import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/achievment_provider.dart';
import '../widgets/achivement_widget.dart';

class AchievementView extends StatelessWidget {
  const AchievementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final achievementProvider = Provider.of<AchievementProvider>(context, listen: false);

    return FutureBuilder(
      future: achievementProvider.fetchAchievements(), // Pobranie danych
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Błąd: ${snapshot.error}"));
        } else {
          return Scaffold(
            appBar: AppBar(centerTitle: true, title: const Text("Osiągnięcia")),
            body: Consumer<AchievementProvider>(
              builder: (context, achievementProvider, child) {
                if (achievementProvider.achievements.isEmpty) {
                  return const Center(child: Text("Brak osiągnięć"));
                } else {
                  return ListView.builder(
                    itemCount: achievementProvider.achievements.length,
                    itemBuilder: (context, index) {
                      final record = achievementProvider.achievements[index];
                      return AchivementWidget(record: record);
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
