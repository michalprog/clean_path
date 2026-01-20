import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '/utils_files/timer_utils.dart';
import '/providers/database_provider.dart';

class TimerWidget extends StatefulWidget {
  final Function(int option) timerFunction;
  bool timerState = false;
  final int startCounter;
  TimerWidget({
    super.key,
    required this.timerFunction,
    required this.startCounter,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late StopWatchTimer _stopWatchTimer;

  static const int countdownStart = 1 * 86400000; // 1 dzień = 86 400 000 ms

  @override
  void initState() {
    super.initState();
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      presetMillisecond: widget.startCounter,
    );
    if (widget.startCounter > 0) {
      _stopWatchTimer.onStartTimer();
      widget.timerState = true;
    }
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  String _formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int days = (seconds / 86400).truncate();
    int hours = ((seconds % 86400) / 3600).truncate();
    int minutes = ((seconds % 3600) / 60).truncate();
    int remainingSeconds = seconds % 60;

    String formattedDays = days.toString().padLeft(2, '0');
    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    return "$formattedDays d $formattedHours h $formattedMinutes m $formattedSeconds s";
  }

  String _mainFormatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int days = (seconds / 86400).truncate();
    int hours = ((seconds % 86400) / 3600).truncate();
    int minutes = ((seconds % 3600) / 60).truncate();
    int remainingSeconds = seconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    String formattedDays;
    if (days < 10) {
      formattedDays = days.toString();
    } else if (days < 100) {
      formattedDays = days.toString().padLeft(2, '0');
    } else {
      formattedDays = days.toString().padLeft(3, '0');
    }

    return "$formattedHours : $formattedMinutes : $formattedSeconds\n"
        "$formattedDays d";
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseProvider>(context);

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

            const SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // RESET / START
                ElevatedButton(
                  onPressed: () => timerFunction(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    widget.timerState ? Colors.red.shade600 : Colors.green.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(widget.timerState ? "Reset" : "Start"),
                ),

                const SizedBox(width: 16),

                // MOTIVATION BUTTON
                ElevatedButton(
                  onPressed: () => widget.timerFunction(3),
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


  Future<void> timerFunction() async {
    final wasRunning = widget.timerState;
    if (wasRunning) {
      final shouldReset = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Are you sure?", textAlign: TextAlign.center),
            content: const Text(
              "Do you want to reset the timer?",
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
                child: const Text("Cancel"),
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
                child: const Text("Reset"),
              ),
            ],
          );
        },
      );

      if (shouldReset != true) {
        return;
      }
    }

    if (!mounted) {
      return;
    }
    if (wasRunning) {
      setState(() {
        _stopWatchTimer.onResetTimer();
        widget.timerFunction(2);
        widget.timerState = false;
      });
      TimerUtils.showMotivationPopup(
        context,
        onTryAgain: () async {
          await _startTimerWithRecord();
        },
      );
      return;
    }

    _startTimerWithRecord();
  }

  void _startStopwatch() {
    if (!mounted) {
      return;
    }
    setState(() {
      _stopWatchTimer.onResetTimer();
      _stopWatchTimer.onStartTimer();
      widget.timerState = true;
    });
  }

  Future<void> _startTimerWithRecord() async {
    widget.timerFunction(1);
    _startStopwatch();
  }
}
