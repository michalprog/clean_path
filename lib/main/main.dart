import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/achievment_provider.dart';
import '/providers/alcochol_provider.dart';
import '/providers/database_provider.dart';
import '/providers/fap_provider.dart';
import '/providers/pap_provider.dart';
import '/providers/statistics_provider.dart';
import '/providers/sweets_provider.dart';
import 'clean_path_main.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ChangeNotifierProxyProvider<DatabaseProvider, FapProvider>(
        create: (_) => FapProvider(DatabaseProvider()),
        update: (_, databaseProvider, __) => FapProvider(databaseProvider),
      ),
      ChangeNotifierProxyProvider<DatabaseProvider, PapProvider>(
        create: (_) => PapProvider(DatabaseProvider()),
        update: (_, databaseProvider, __) => PapProvider(databaseProvider),
      ),
      ChangeNotifierProxyProvider<DatabaseProvider, AlcocholProvider>(
        create: (_) => AlcocholProvider(DatabaseProvider()),
        update: (_, databaseProvider, __) => AlcocholProvider(databaseProvider),
      ),
      ChangeNotifierProxyProvider<DatabaseProvider, SweetsProvider>(
        create: (_) => SweetsProvider(DatabaseProvider()),
        update: (_, databaseProvider, __) => SweetsProvider(databaseProvider),
      ),
      ChangeNotifierProxyProvider<DatabaseProvider, StatisticsProvider>(
        create: (_) => StatisticsProvider(DatabaseProvider()),
        update: (_, databaseProvider, __) => StatisticsProvider(databaseProvider),
      ),
      ChangeNotifierProxyProvider<DatabaseProvider, AchievementProvider>(
        create: (_) => AchievementProvider(DatabaseProvider()),
        update: (_, databaseProvider, __) => AchievementProvider(databaseProvider),
      ),



    ],
    child: CleanPathMain(),
  ),
  );
}


