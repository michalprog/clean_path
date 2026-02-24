import 'package:clean_path/providers/account_provider.dart';
import 'package:clean_path/sqlflite/daily_login_dao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '/l10n/app_localizations.dart';

class AccoutCalendarView extends StatefulWidget {
  const AccoutCalendarView({super.key});

  @override
  State<AccoutCalendarView> createState() => _AccoutCalendarViewState();
}

class _AccoutCalendarViewState extends State<AccoutCalendarView> {
  final DailyLoginDao _dailyLoginDao = DailyLoginDao();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Set<DateTime> _loginDays = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoginDays();
  }

  Future<void> _loadLoginDays() async {
    final username = context.read<AccountProvider>().user?.username;

    if (username == null || username.isEmpty) {
      setState(() {
        _loginDays = {};
        _isLoading = false;
      });
      return;
    }

    final loginDays = await _dailyLoginDao.getLoginDaysForUser(username);
    if (!mounted) {
      return;
    }

    setState(() {
      _loginDays = loginDays;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final l10n = AppLocalizations.of(context)!;
    final selectedDayKey = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    final didLoginSelectedDay = _loginDays.contains(selectedDayKey);

    return Column(
      children: [
        TableCalendar(
          locale: Localizations.localeOf(context).toString(),
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
          eventLoader: (day) {
            final key = DateTime(day.year, day.month, day.day);
            return _loginDays.contains(key) ? [key] : [];
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              final key = DateTime(day.year, day.month, day.day);
              if (_loginDays.contains(key)) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            defaultBuilder: (context, day, focusedDay) {
              return _buildDayCell(day);
            },
            todayBuilder: (context, day, focusedDay) {
              return _buildDayCell(day, isToday: true);
            },
            selectedBuilder: (context, day, focusedDay) {
              return _buildDayCell(day, isSelected: true);
            },
            outsideBuilder: (context, day, focusedDay) {
              return _buildDayCell(day, isOutside: true);
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    didLoginSelectedDay ? Icons.check_circle : Icons.cancel,
                    color: didLoginSelectedDay ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      didLoginSelectedDay
                          ? 'Użytkownik zalogował się tego dnia.'
                          : 'Brak logowania użytkownika tego dnia.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container()
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(
      DateTime day, {
        bool isOutside = false,
        bool isSelected = false,
        bool isToday = false,
      }) {
    final key = DateTime(day.year, day.month, day.day);
    final hasLogin = _loginDays.contains(key);

    final Color? bgColor = isSelected
        ? Theme.of(context).colorScheme.primary.withOpacity(0.85)
        : (hasLogin ? Colors.green.withOpacity(0.25) : null);

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
}