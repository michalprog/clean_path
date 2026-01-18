import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '/providers/daily_tasks_provider.dart';

class DailyTaskCalendar extends StatefulWidget {
  final int taskType;

  const DailyTaskCalendar({
    super.key,
    required this.taskType,
  });

  @override
  State<DailyTaskCalendar> createState() => _DailyTaskCalendarState();
}

class _DailyTaskCalendarState extends State<DailyTaskCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _normalizeDay(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  Widget _buildDayCell(
      DateTime day, {
        required Set<DateTime> completedDays,
        bool isOutside = false,
        bool isSelected = false,
        bool isToday = false,
      }) {
    final normalized = _normalizeDay(day);
    final isCompleted = completedDays.contains(normalized);
    final Color? background = isSelected
        ? Theme.of(context).colorScheme.primary
        : isCompleted
        ? Colors.green.withOpacity(0.2)
        : null;

    final textColor = isSelected
        ? Colors.white
        : isOutside
        ? Colors.grey
        : Colors.black87;

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: background,
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

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        const Text('Wykonano'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DateTime>>(
      future: context
          .watch<DailyTasksProvider>()
          .fetchCompletionDatesForType(widget.taskType),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final completedDays = snapshot.data!
            .map(_normalizeDay)
            .toSet();

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
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return _buildDayCell(
                    day,
                    completedDays: completedDays,
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildDayCell(
                    day,
                    completedDays: completedDays,
                    isToday: true,
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildDayCell(
                    day,
                    completedDays: completedDays,
                    isSelected: true,
                  );
                },
                outsideBuilder: (context, day, focusedDay) {
                  return _buildDayCell(
                    day,
                    completedDays: completedDays,
                    isOutside: true,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildLegend(),
          ],
        );
      },
    );
  }
}