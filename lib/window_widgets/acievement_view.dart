import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/achievment_provider.dart';

class AcievementView extends StatelessWidget {
  const AcievementView({super.key});

  @override
  Widget build(BuildContext context) {
    AchievementProvider achievementProvider=Provider.of<AchievementProvider>(context);
    return FutureBuilder(
      future: achievementProvider.statisticInicjalization(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Błąd: ${snapshot.error}"));
        } else {
          return Container(

          );
        }
      },
    );
  }
}
