import 'package:clean_path/statistc_views/statistic_universal_calendar_view.dart';
import 'package:clean_path/statistc_views/statistics_trails_view.dart';
import 'package:clean_path/window_widgets/uniwersal_statistics_view.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '/l10n/app_localizations.dart';
import '/enums/enums.dart';
import 'all_attemps_list.dart';
import 'daily_task_statistics_page.dart';
import 'main_statistcs_view.dart';

class MainStatistic extends StatefulWidget {
  final int index;
  const MainStatistic({super.key, required this.index});

  @override
  State<MainStatistic> createState() => _MainStatisticState();
}

class _MainStatisticState extends State<MainStatistic> {
  bool isExpanded = false;
  late final List<Widget> showViews;
  int navigationIndex = 4;

  @override
  void initState() {
    super.initState();

    showViews = [
      PageView(
        children: const [
          UniwersalStatisticsView(type: AddictionTypes.fap),
          StatisticUniversalCalendarView(
            key: ValueKey(AddictionTypes.fap),
            type: AddictionTypes.fap,
          ),
        ],
      ),
      PageView(
        children: const [
          UniwersalStatisticsView(type: AddictionTypes.smoking),
          StatisticUniversalCalendarView(
            key: ValueKey(AddictionTypes.smoking),
            type: AddictionTypes.smoking,
          ),
        ],
      ),
      PageView(
        children: const [
          UniwersalStatisticsView(type: AddictionTypes.alcochol),
          StatisticUniversalCalendarView(
            key: ValueKey(AddictionTypes.alcochol),
            type: AddictionTypes.alcochol,
          ),
        ],
      ),
      PageView(
        children: const [
          UniwersalStatisticsView(type: AddictionTypes.sweets),
          StatisticUniversalCalendarView(
            key: ValueKey(AddictionTypes.sweets),
            type: AddictionTypes.sweets,
          ),
        ],
      ),
      MainStatistcsView(),
      PageView(children: const [StatisticsTrailsView(), AllAttempsList()]),
      const DailyTaskStatisticsPage(), // <- upewniamy się, że jest const jeśli się da
    ];

    // zabezpieczenie indeksu z zewnątrz
    navigationIndex = widget.index.clamp(0, showViews.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final appBarTexts = [
      l10n.noFapStatus,
      l10n.noSmokingStatus,
      l10n.noAlcoholStatus,
      l10n.noSweetStatus,
      l10n.drawerStatistics,
      l10n.timesOfTrials,
      l10n.dailyTaskTitle, // <- DODANE: tytuł dla DailyTaskStatisticsPage (index 6)
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Text(
          appBarTexts[navigationIndex],
          textAlign: TextAlign.center,
        ),
      ),
      body: showViews[navigationIndex],

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isExpanded) ...[
            FloatingActionButton(
              heroTag: "fab_fap",
              mini: true,
              onPressed: () => switchViews(0),
              child: const Icon(Icons.girl),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "fab_smoking",
              mini: true,
              onPressed: () => switchViews(1),
              child: const Icon(Icons.smoking_rooms),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "fab_alcohol",
              mini: true,
              onPressed: () => switchViews(2),
              child: const Icon(Icons.liquor),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "fab_sweets",
              mini: true,
              onPressed: () => switchViews(3),
              child: const Icon(HugeIcons.strokeRoundedCottonCandy),
            ),
            const SizedBox(height: 8),
          ],
          FloatingActionButton(
            heroTag: "fab_main",
            onPressed: () => setState(() => isExpanded = !isExpanded),
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
            IconButton(onPressed: () => switchViews(4), icon: const Icon(Icons.home)),
            IconButton(onPressed: () => switchViews(6), icon: const Icon(Icons.fitness_center)), // <- DailyTaskStatisticsPage
            IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
            IconButton(onPressed: () => switchViews(5), icon: const Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }

  void switchViews(int view) {
    setState(() {
      navigationIndex = view.clamp(0, showViews.length - 1);
    });
  }
}
