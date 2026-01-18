import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '/utils_files/daily_task_utils.dart';
import '/widgets/daily_task_calendar.dart';

class DailyTaskCalendarView extends StatefulWidget {
  const DailyTaskCalendarView({super.key});

  @override
  State<DailyTaskCalendarView> createState() => _DailyTaskCalendarViewState();
}

class _DailyTaskCalendarViewState extends State<DailyTaskCalendarView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Material(
          elevation: 1,
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: List.generate(
              4,
                  (index) => Tab(
                    icon: DailyTaskUtils.iconForType(index + 1),
                  ),

            ),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _index,
            children: const [
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



