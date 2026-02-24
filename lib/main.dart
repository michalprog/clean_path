import 'package:clean_path/main/notification_service.dart';
import 'package:clean_path/providers/daily_tasks_provider.dart';
import 'package:clean_path/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/achievment_provider.dart';
import '/providers/alcochol_provider.dart';
import '/providers/database_provider.dart';
import '/providers/fap_provider.dart';
import '/providers/pap_provider.dart';
import '/providers/statistics_provider.dart';
import '/providers/account_provider.dart';
import '/providers/sweets_provider.dart';
import 'main/clean_path_main.dart';
import '/main/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  final accountProvider = getIt<AccountProvider>();
  await accountProvider.loadUser();
  final notificationService = getIt<NotificationService>();
  await notificationService.scheduleNotificationsFromTomorrow();
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
        ChangeNotifierProvider<DailyTasksProvider>(
          create: (_) => DailyTasksProvider()..initialize(),
        ),
        ChangeNotifierProvider<AccountProvider>.value(
          value: accountProvider,
        ),
      ],
      child: CleanPathMain(),
    ),
  );
}