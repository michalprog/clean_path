import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/utils_files/statistic_utils.dart';
import 'trial_widget.dart';
import '/data_types/record.dart';
import 'package:table_calendar/table_calendar.dart';
import '/providers/statistics_provider.dart';

class StatisticsTrailsView extends StatefulWidget {
  const StatisticsTrailsView({super.key});

  @override
  State<StatisticsTrailsView> createState() => _StatisticsTrailsViewState();
}

class _StatisticsTrailsViewState extends State<StatisticsTrailsView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Record> _allRecords = [];
  List<Record> _selectedDayRecords = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<StatisticsProvider>(context, listen: false);
    provider.provideMainData().then((_) {
      setState(() {
        _allRecords = StatisticUtils.getUnactiveRecords(provider.allRecords);
        _selectedDayRecords = _getRecordsForDay(_selectedDay);
      });
    });
  }

  List<Record> _getRecordsForDay(DateTime day) {
    return _allRecords.where((record) {
      return isSameDay(record.desactivated, day);
    }).toList();
  }

  void _cycleCalendarFormat() {
    setState(() {
      if (_calendarFormat == CalendarFormat.twoWeeks) {
        _calendarFormat = CalendarFormat.month;

      } else if (_calendarFormat == CalendarFormat.week) {
        _calendarFormat = CalendarFormat.twoWeeks;

      } else {
        _calendarFormat = CalendarFormat.week;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _allRecords.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
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
          eventLoader: _getRecordsForDay, // Wczytujemy eventy (czyli wpadki)
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  bottom: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(events.length.clamp(1, 5), (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red, // 🔴 czerwone kropki – wpadki
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

