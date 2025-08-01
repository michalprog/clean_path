import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '/enums/enums.dart';
import '/utils_files/statistic_utils.dart';
import '/data_types/record.dart';
import '/providers/statistics_provider.dart';
import 'trial_widget.dart';

class StatisticUniversalCalendarView extends StatefulWidget {
  final AddictionTypes type;

  const StatisticUniversalCalendarView({Key? key, required this.type})
      : super(key: key);

  @override
  State<StatisticUniversalCalendarView> createState() =>
      _StatisticUniversalCalendarViewState();
}

class _StatisticUniversalCalendarViewState
    extends State<StatisticUniversalCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Record> _allRecords = [];
  List<Record> _selectedDayRecords = [];
  Map<DateTime, List<Record>> _groupedRecords = {};
  Set<DateTime> _activeDays = {};
  Set<DateTime> _failDays = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<StatisticsProvider>(context, listen: false);
    provider.provideMainData().then((_) {
      final records = StatisticUtils.getRecordsByType(
          provider.allRecords, widget.type);
      final grouped = _groupRecords(records);
      final activeDays = provider.getActiveDaysForType(widget.type);
      final failDays = StatisticUtils.getFailDaysFromRecords(records);

      setState(() {
        _allRecords = records;
        _groupedRecords = grouped;
        _activeDays = activeDays;
        _failDays = failDays;
        _selectedDayRecords = _getRecordsForDay(_selectedDay);
        _isLoading = false;
      });
    });
  }

  Map<DateTime, List<Record>> _groupRecords(List<Record> records) {
    final Map<DateTime, List<Record>> grouped = {};
    for (var record in records) {
      final date = DateTime(
        (record.desactivated ?? DateTime.now()).year,
        (record.desactivated ?? DateTime.now()).month,
        (record.desactivated ?? DateTime.now()).day,
      );
      grouped.putIfAbsent(date, () => []).add(record);
    }
    return grouped;
  }

  List<Record> _getRecordsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _groupedRecords[key] ?? [];
  }

  Widget _buildDayCell(
      DateTime day, {
        bool isOutside = false,
        bool isSelected = false,
        bool isToday = false,
      }) {
    final key = DateTime(day.year, day.month, day.day);
    final isActiveDay = _activeDays.contains(key);
    final isFailDay = _failDays.contains(key) && !isActiveDay;

    final Color? bgColor = isSelected
        ? Theme.of(context).colorScheme.primary.withOpacity(0.85)
        : (isFailDay
        ? Colors.red.withOpacity(0.25)
        : (isActiveDay ? Colors.green.withOpacity(0.25) : null));

    final Color textColor = isSelected
        ? Colors.white
        : isOutside
        ? Colors.grey
        : Colors.black87;

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: isToday && !isSelected
            ? Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        )
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _selectedDayRecords = _getRecordsForDay(selectedDay);
            });
          },
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          eventLoader: _getRecordsForDay,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              final key = DateTime(day.year, day.month, day.day);
              final isActiveDay = _activeDays.contains(key);
              final isFailDay = _failDays.contains(key) && !isActiveDay;

              if (isActiveDay || isFailDay) {
                return Positioned(
                  bottom: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(1, (_) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isFailDay ? Colors.red : Colors.green,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _selectedDayRecords.isEmpty
              ? const Center(child: Text("Brak rekordów na ten dzień"))
              : ListView.builder(
            itemCount: _selectedDayRecords.length,
            itemBuilder: (context, index) {
              return TrialWidget(record: _selectedDayRecords[index]);
            },
          ),
        ),
      ],
    );
  }
}
