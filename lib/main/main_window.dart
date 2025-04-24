import 'package:flutter/material.dart';

import '../window_widgets/alk_view.dart';
import '../window_widgets/default_view.dart';
import '../window_widgets/fap_view.dart';
import '../window_widgets/pap_view.dart';
import 'main_view.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {

  List<Widget> show_view = [];
  List<String> AppBarText = [];
  int NavigationIndex = 4;

  @override
  void initState() {
    super.initState();
    show_view = [
      FapView(),
      PapView(),
      AlkView(),
      DefaultView(),
      MainView(),


    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Center(
            child: Text(
              "CleanPath",
              textAlign: TextAlign.center,
            )),
        backgroundColor: Colors.greenAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => changeWindow(4),
        child: const Icon(Icons.home, color: Colors.purple),
        backgroundColor: Colors.purple.shade100,
        shape: CircleBorder(

        ),
        elevation: 5,
      ),
      body: show_view[NavigationIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.purple.shade50,
        elevation: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => changeWindow(0), icon: Icon(Icons.girl)),
            IconButton(onPressed: () => changeWindow(1),
                icon: Icon(Icons.smoking_rooms)),
            SizedBox(width: 40),
            IconButton(
                onPressed: () => changeWindow(2), icon: Icon(Icons.liquor)),
            IconButton(
                onPressed: () => changeWindow(3), icon: Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }

  void changeWindow(int page) {
    setState(() {
      NavigationIndex = page;
    });
  }
}
