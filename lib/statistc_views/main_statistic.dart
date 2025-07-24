import 'package:clean_path/statistc_views/statistic_universal_calendar_view.dart';
import 'package:clean_path/statistc_views/statistics_trails_view.dart';
import 'package:clean_path/window_widgets/uniwersal_statistics_view.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '/enums/enums.dart';
import 'all_attemps_list.dart';
import 'main_statistcs_view.dart';

class MainStatistic extends StatefulWidget {
  final int index;
  const MainStatistic({super.key, required this.index});

  @override
  State<MainStatistic> createState() => _MainStatisticState();
}

class _MainStatisticState extends State<MainStatistic> {
  bool isExpanded = false;
  List<Widget> showViews = [];
  List<String> AppBarTexts = [];
  int NavigationIndex = 4;
  @override
  void initState() {
    NavigationIndex = widget.index;
    showViews = [
      //StatisticUniversalCalendarView()



      PageView(children: const [UniwersalStatisticsView(type: AddictionTypes.fap),StatisticUniversalCalendarView(type:AddictionTypes.fap)]),
      PageView(children: const [UniwersalStatisticsView(type: AddictionTypes.smoking),StatisticUniversalCalendarView(type:AddictionTypes.smoking)]),
      PageView(children: const [UniwersalStatisticsView(type: AddictionTypes.alcochol),StatisticUniversalCalendarView(type:AddictionTypes.alcochol)]),
      PageView(children: const [UniwersalStatisticsView(type: AddictionTypes.sweets),StatisticUniversalCalendarView(type:AddictionTypes.sweets)]),

      MainStatistcsView(),
      PageView(children: const [StatisticsTrailsView(), AllAttempsList()]),
    ];
    AppBarTexts = [
      "No Fap statistics",
      "No smoking statistics",
      "No alcohol statistics",
      "No sweets statistics",
      "Overall statistics",
      "all attempts",
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Text(AppBarTexts[NavigationIndex], textAlign: TextAlign.center),
      ),
      body: showViews[NavigationIndex],
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isExpanded) ...[
            FloatingActionButton(
              heroTag: "1",
              mini: true,
              onPressed: () => switchViews(0),
              child: Icon(Icons.girl),
            ),
            SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "2",
              mini: true,
              onPressed: () => switchViews(1),
              child: Icon(Icons.smoking_rooms),
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "2",
              mini: true,
              onPressed: () => switchViews(2),
              child: Icon(Icons.liquor),
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "2",
              mini: true,
              onPressed: () => switchViews(3),
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
            IconButton(onPressed: () => switchViews(4), icon: Icon(Icons.home)),
            IconButton(onPressed: () => switchViews(5), icon: Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }

  void switchViews(int view) {
    setState(() {
      NavigationIndex = view;
    });
  }
}
