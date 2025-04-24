import 'package:clean_path/main/main_window.dart';
import 'package:flutter/material.dart';

class CleanPathMain extends StatelessWidget {
  const CleanPathMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CleanPath",

      home: MainWindow(),
    );
  }
}
