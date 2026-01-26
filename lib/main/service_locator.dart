import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '/data_types/leveling_service.dart';
import '/sqlflite/database_manager.dart';
import '/providers/settings_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<DatabaseManager>(() => DatabaseManager());
  getIt.registerSingletonAsync<Database>(
    () => getIt<DatabaseManager>().database,
  );

  getIt.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  getIt.registerSingletonWithDependencies<SettingsStorage>(
    () => SettingsStorage(getIt<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );

  getIt.registerLazySingleton<LevelingService>(
    () => const DefaultLevelingService(),
  );

  await getIt.allReady();
}
