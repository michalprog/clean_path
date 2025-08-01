import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:clean_path/main/drawer_widget.dart';
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
        centerTitle: true,
        title: Text(
          "CleanPath",
        ),
        backgroundColor: Colors.greenAccent,
      ),
      drawer: DrawerWidget( index: NavigationIndex,),
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
              onPressed: () => changeWindow(0),
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0), // lekko przesunięta lewa ikona
                    child: FaIcon(FontAwesomeIcons.mars, /*color: Colors.blue*/),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0), // lekko przesunięta prawa ikona
                    child: FaIcon(FontAwesomeIcons.venus, /*color: Colors.pink*/),
                  ),
                ],
              ),
            ),
            IconButton(onPressed: () => changeWindow(1),
                icon: Icon(Icons.smoking_rooms)),
            SizedBox(width: 40),
            IconButton(
                onPressed: () => changeWindow(2), icon: Icon(Icons.liquor)),
            IconButton(
                onPressed: () => changeWindow(3), icon: Icon(HugeIcons.strokeRoundedCottonCandy)),
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
