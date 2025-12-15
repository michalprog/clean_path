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
        ChangeNotifierProxyProvider<DatabaseProvider, FapProvider>(
          create: (_) => FapProvider(),
          update: (_, dbProvider, fapProvider) =>
          fapProvider!..update(dbProvider),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, PapProvider>(
          create: (_) => PapProvider(),
          update: (_, dbProvider, papProvider) =>
          papProvider!..update(dbProvider),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, AlcocholProvider>(
          create: (_) => AlcocholProvider(),
          update: (_, dbProvider, alcProvider) =>
          alcProvider!..update(dbProvider),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, SweetsProvider>(
          create: (_) => SweetsProvider(),
          update: (_, dbProvider, sweetsProvider) =>
          sweetsProvider!..update(dbProvider),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, StatisticsProvider>(
          create: (_) => StatisticsProvider(),
          update: (_, dbProvider, statsProvider) =>
          statsProvider!..update(dbProvider),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, AchievementProvider>(
          create: (_) => AchievementProvider(),
          update: (_, dbProvider, achProvider) =>
          achProvider!..update(dbProvider),
        ),
      ],
      child: CleanPathMain(),
    ),
  );
}



