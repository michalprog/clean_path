import 'package:clean_path/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/achievment_provider.dart';
import '/providers/alcochol_provider.dart';
import '/providers/database_provider.dart';
import '/providers/fap_provider.dart';
import '/providers/pap_provider.dart';
import '/providers/statistics_provider.dart';
import '/providers/sweets_provider.dart';
import 'clean_path_main.dart';
import '/main/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(),
        ),
        ChangeNotifierProvider<FapProvider>(
          create: (_) => FapProvider(),
        ),
        ChangeNotifierProvider<PapProvider>(
          create: (_) => PapProvider(),
        ),
        ChangeNotifierProvider<AlcocholProvider>(
          create: (_) => AlcocholProvider(),
        ),
        ChangeNotifierProvider<SweetsProvider>(
          create: (_) => SweetsProvider(),
        ),
        ChangeNotifierProvider<StatisticsProvider>(
          create: (_) => StatisticsProvider(),
        ),
        ChangeNotifierProvider<AchievementProvider>(
          create: (_) => AchievementProvider(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: CleanPathMain(),
    ),
  );
}



