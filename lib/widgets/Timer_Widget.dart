import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '/enums/enums.dart';
import '/main/service_locator.dart';
import '/providers/account_provider.dart';
import '/providers/settings_storage.dart';

class TimerWidget extends StatefulWidget {
  final void Function(int option) timerFunction;
  final int startCounter; // ms
  final AddictionTypes addictionType;
  final DateTime? recordActivated;

  const TimerWidget({
    super.key,
    required this.timerFunction,
    required this.startCounter,
    required this.addictionType,
    required this.recordActivated,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late final StopWatchTimer _stopWatchTimer;
  StreamSubscription<int>? _timerSubscription;

  bool _isRunning = false;
  int _lastObservedDays = -1;

  static const int _millisecondsPerDay = 86400000;

  @override
  void initState() {
    super.initState();

    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      presetMillisecond: widget.startCounter,
    );

    // start, jeśli przychodzimy z już działającym licznikiem
    if (widget.startCounter > 0) {
      _stopWatchTimer.onStartTimer();
      _isRunning = true;
    }

    _timerSubscription = _stopWatchTimer.rawTime.listen(_handleTimerTick);
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    _stopWatchTimer.dispose();
    super.dispose();
  }

  String _mainFormatTime(int milliseconds) {
    final seconds = (milliseconds / 1000).truncate();
    final days = (seconds / 86400).truncate();
    final hours = ((seconds % 86400) / 3600).truncate();
    final minutes = ((seconds % 3600) / 60).truncate();
    final remainingSeconds = seconds % 60;

    final formattedHours = hours.toString().padLeft(2, '0');
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    // dni: 0..9 -> "0", 10..99 -> "10", 100+ -> "100"
    final formattedDays = days < 10
        ? days.toString()
        : (days < 100 ? days.toString().padLeft(2, '0') : days.toString().padLeft(3, '0'));

    return "$formattedHours : $formattedMinutes : $formattedSeconds\n$formattedDays d";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              builder: (context, snapshot) {
                final value = snapshot.data ?? widget.startCounter;
                return Text(
                  _mainFormatTime(value),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimerWithRecord,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: !_isRunning ? null : _stopTimer,
                  child: const Text('Stop'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ],
    );
  }

  void _startStopwatchFromZero() {
    if (!mounted) return;
    _stopWatchTimer.onResetTimer();
    _stopWatchTimer.onStartTimer();
  }

  Future<void> _startTimerWithRecord() async {
    // sygnał do rodzica (Twoja logika: option=1)
    widget.timerFunction(1);

    if (!mounted) return;
    setState(() {
      _startStopwatchFromZero();
      _isRunning = true;
      _lastObservedDays = -1; // reset obserwacji dni po nowym starcie
    });
  }

  void _stopTimer() {
    if (!mounted) return;
    setState(() {
      _stopWatchTimer.onStopTimer();
      _isRunning = false;
    });
  }

  void _resetTimer() {
    if (!mounted) return;
    setState(() {
      _stopWatchTimer.onResetTimer();
      _isRunning = false;
      _lastObservedDays = -1;
    });
  }

  Future<void> _handleTimerTick(int milliseconds) async {
    if (!mounted) return;

    final recordActivated = widget.recordActivated;
    if (recordActivated == null || milliseconds <= 0) return;

    final days = milliseconds ~/ _millisecondsPerDay;
    if (days == _lastObservedDays) return;

    _lastObservedDays = days;
    await _applyTimerDayRewards(days, recordActivated);
  }

  Future<void> _applyTimerDayRewards(int days, DateTime recordActivated) async {
    if (days <= 0) return;

    final settingsStorage = getIt<SettingsStorage>();
    final accountProvider = context.read<AccountProvider>();

    final storedStart = await settingsStorage.loadTimerStart(widget.addictionType);
    final currentStart = recordActivated.toIso8601String();

    // nowy rekord -> reset licznika nagród
    if (storedStart != currentStart) {
      await settingsStorage.saveTimerStart(widget.addictionType, recordActivated);
      await settingsStorage.saveTimerRewardedDays(widget.addictionType, 0);
    }

    final rewardedDays = await settingsStorage.loadTimerRewardedDays(widget.addictionType);
    if (days <= rewardedDays) return;

    final newlyCompletedDays = days - rewardedDays;
    for (var i = 0; i < newlyCompletedDays; i++) {
      await accountProvider.applyLevelingAction(LevelingAction.timerDayCompleted);
    }

    await settingsStorage.saveTimerRewardedDays(widget.addictionType, days);
  }
}
