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
              onPressed: () => changeview(0),
              icon: Icon(Icons.list_alt_outlined),
            ),
            IconButton(
              onPressed: () => changeview(1),
              icon: Icon(Icons.fitness_center_sharp),
            ),
            IconButton(
              onPressed: () => changeview(2),
              icon: Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
    );
  }

  void changeview(int view) {
    setState(() {
      showViewIndex = view;
    });

  }
}
