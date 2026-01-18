import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '/utils_files/daily_task_utils.dart';

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
              CalendarA(),
              CalendarB(),
              CalendarC(),
              CalendarD(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Poniżej podstawiasz swoje 4 „kalendarze”
/// (np. różne konfiguracje TableCalendar/SfCalendar, różne źródła danych itp.)

class CalendarA extends StatelessWidget {
  const CalendarA({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tu jest Kalendarz 1'));
  }
}

class CalendarB extends StatelessWidget {
  const CalendarB({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tu jest Kalendarz 2'));
  }
}

class CalendarC extends StatelessWidget {
  const CalendarC({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tu jest Kalendarz 3'));
  }
}

class CalendarD extends StatelessWidget {
  const CalendarD({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tu jest Kalendarz 4'));
  }
}

