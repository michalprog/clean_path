import 'package:clean_path/providers/database_provider.dart';
import 'package:flutter/material.dart';
import '/enums/enums.dart';

class AchievementProvider extends ChangeNotifier {
  late final DatabaseProvider databaseProvider;

  AchievementProvider(this.databaseProvider);
}
