import 'package:clean_path/window_widgets/uniwersal_statistics_view.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../enums/enums.dart';
import 'main_statistcs_view.dart';

class MainStatistic extends StatefulWidget {
  final int index;
  const MainStatistic({super.key, required this.index});

  @override
  State<MainStatistic> createState() => _MainStatisticState();
}

class _MainStatisticState extends State<MainStatistic> {
  bool isExpanded = false;
  List<Widget> show_views = [];
  List<String> AppBarTexts = [];
  int NavigationIndex = 4;
  @override
  void initState() {
    NavigationIndex = widget.index;
show_views=[
  UniwersalStatisticsView(type: AddictionTypes.fap),
  UniwersalStatisticsView(type: AddictionTypes.smoking),
  UniwersalStatisticsView(type: AddictionTypes.alcochol),
  UniwersalStatisticsView(type: AddictionTypes.sweets),
  MainStatistcsView(),
  
];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Statistic", textAlign: TextAlign.center),
      ),
      body: show_views[NavigationIndex],
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isExpanded) ...[
            FloatingActionButton(
              heroTag: "1",
              mini: true,
              onPressed: () =>switchViews(0),
              child: Icon(Icons.girl),
            ),
            SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "2",
              mini: true,
              onPressed: () =>switchViews(1),
              child: Icon(Icons.smoking_rooms),
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "2",
              mini: true,
              onPressed: () =>switchViews(2),
              child: Icon(Icons.liquor),
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "2",
              mini: true,
              onPressed: () =>switchViews(3),
              child: Icon(HugeIcons.strokeRoundedCottonCandy),
            ),
            SizedBox(height: 8),
          ],
          FloatingActionButton(
            heroTag: "main",
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Icon(isExpanded ? Icons.close : Icons.add),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.purple.shade50,
        elevation: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () =>switchViews(4), icon: Icon(Icons.home)),
            IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }
  void switchViews(int view)
  {
    setState(() {
      NavigationIndex=view;
    });
  }
}
