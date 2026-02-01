import 'package:flutter/material.dart';

import '/l10n/app_localizations.dart';
import 'daily_task_calendar_view.dart';
import 'daily_task_statistics_view.dart';
import 'daily_task_view.dart';

class DailyTaskMainView extends StatefulWidget {
  const DailyTaskMainView({super.key});

  @override
  State<DailyTaskMainView> createState() => _DailyTaskMainViewState();
}

class _DailyTaskMainViewState extends State<DailyTaskMainView> {
  List<Widget> showView = [];
  int showViewIndex = 1;

  @override
  void initState() {
    super.initState();
    showView = [
      DailyTaskStatisticsView(),
      DailyTaskView(),
      DailyTaskCalendarView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Text(l10n.dailyTaskTitle),
      ),
      body: showView[showViewIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: showViewIndex,
        onTap: changeview,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt_outlined),
            label: l10n.dailyTaskListTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center_sharp),
            label: l10n.dailyTaskTaskTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            label: l10n.dailyTaskCalendarTab,
          ),
        ],
      ),
    );
  }

  void changeview(int view) {
    setState(() {
      showViewIndex = view;
    });

  }
}
