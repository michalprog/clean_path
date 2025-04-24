import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'clean_path_main.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider.value(value: null),
    ],
    child: CleanPathMain(),
  ),
  );
}
/*runApp(
      CleanPathMain());


*/
