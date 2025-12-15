import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '/sqlflite/database_manager.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<DatabaseManager>(() => DatabaseManager());
  getIt.registerSingletonAsync<Database>(() => getIt<DatabaseManager>().database);

  await getIt.allReady();
}