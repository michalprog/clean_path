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
      ChangeNotifierProvider(create: (_) => FapProvider()),
      ChangeNotifierProvider(create: (_) => PapProvider()),
      ChangeNotifierProvider(create: (_) => AlcocholProvider()),
      ChangeNotifierProvider(create: (_) => SweetsProvider()),

    ],
    child: CleanPathMain(),
  ),
  );
}
/*runApp(
      CleanPathMain());


*/
