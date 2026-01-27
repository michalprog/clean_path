import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '/enums/enums.dart';
import '/main/service_locator.dart';
import '/providers/account_provider.dart';
import '/providers/settings_storage.dart';
import '/utils_files/timer_utils.dart';

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
          children: [
            const SizedBox(height: 220),
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

            const SizedBox(height: 200),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _handleMainButtonPress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.red.shade600 : Colors.green.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(_isRunning ? 'Reset' : 'Start'),
                ),

                const SizedBox(width: 16),

                ElevatedButton(
                  onPressed: _showMotivationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Icon(Icons.lightbulb_outline),
                ),
              ],
            ),

            const SizedBox(height: 90),
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

  Future<void> _handleMainButtonPress() async {
    if (_isRunning) {
      final shouldReset = await _confirmReset();
      if (shouldReset != true) return;
      if (!mounted) return;
      setState(() {
        _stopWatchTimer.onResetTimer();
        _isRunning = false;
        _lastObservedDays = -1;
      });
      widget.timerFunction(2);
      TimerUtils.showMotivationPopup(
        context,
        onTryAgain: _startTimerWithRecord,
      );
      return;
    }

    await _startTimerWithRecord();
  }

  Future<bool?> _confirmReset() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Are you sure?', textAlign: TextAlign.center),
          content: const Text(
            'Do you want to reset the timer?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 12),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _showMotivationDialog() {
    final quote = TimerUtils.giveMotivationMessage();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Motivation', textAlign: TextAlign.center),
          content: Text(
            quote,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Thanks!'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleTimerTick(int milliseconds) async {
    if (!mounted) return;

    final recordActivated = widget.recordActivated;
    if (recordActivated == null || milliseconds <= 0) return;

    final days = milliseconds ~/ Duration.millisecondsPerDay;
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
