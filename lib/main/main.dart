import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/alcochol_provider.dart';
import '../providers/database_provider.dart';
import '../providers/fap_provider.dart';
import '../providers/pap_provider.dart';
import '../providers/sweets_provider.dart';
import 'clean_path_main.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ProxyProvider<DatabaseProvider, FapProvider>(
        update: (_, databaseProvider, __) => FapProvider(databaseProvider),
      ),
      ProxyProvider<DatabaseProvider, PapProvider>(
        update: (_, databaseProvider, __) => PapProvider(databaseProvider),
      ),
      ProxyProvider<DatabaseProvider, AlcocholProvider>(
        update: (_, databaseProvider, __) => AlcocholProvider(databaseProvider),
      ),
      ProxyProvider<DatabaseProvider, SweetsProvider>(
        update: (_, databaseProvider, __) => SweetsProvider(databaseProvider),
      ),
    ],
    child: CleanPathMain(),
  ),
  );
}
/*runApp(
      CleanPathMain());


*/
