import 'package:clean_path/window_widgets/daily_task_views/daily_task_calendar.dart';
import 'package:clean_path/window_widgets/daily_task_views/daily_task_statistics_view.dart';
import 'package:flutter/material.dart';
import '/utils_files/daily_task_utils.dart';

class DailyTaskStatisticsPage extends StatefulWidget {
  const DailyTaskStatisticsPage({super.key});

  @override
  State<DailyTaskStatisticsPage> createState() => _DailyTaskStatisticsPageState();
}

class _DailyTaskStatisticsPageState extends State<DailyTaskStatisticsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _index = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 1,
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: [
              Tab(
                child: Text(
                  DailyTaskUtils.markerForMenu(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              ...List.generate(
                4,
                    (index) => Tab(
                  child: Text(
                    DailyTaskUtils.markerForTaskType(index),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _index,
            children:  [
              DailyTaskStatisticsView(),
              DailyTaskCalendar(taskType: 1),
              DailyTaskCalendar(taskType: 2),
              DailyTaskCalendar(taskType: 3),
              DailyTaskCalendar(taskType: 4)
            ],
          ),
        ),
      ],
    );
  }
}