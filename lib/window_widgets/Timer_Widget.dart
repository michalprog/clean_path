import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../providers/database_provider.dart';

class TimerWidget extends StatefulWidget {
  final Function(int option) timerFunction;
  bool TimerState=false;
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
      widget.TimerState=true;
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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

        SizedBox(height: 150),

        StreamBuilder<int>(
          stream: _stopWatchTimer.rawTime,
          builder: (context, snapshot) {
            final value = snapshot.data ?? widget.startCounter;
            final countdownTime = countdownStart - value;

            return Text(
              "To next Achievement: ${_formatTime(countdownTime)}",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            );
          },
        ),

        SizedBox(height: 20),
        ElevatedButton(onPressed: () => timerFunction(), child: Text(widget.TimerState ? "Reset" : "Start"),),
        SizedBox(height: 30),
      ],
    );
  }

  void timerFunction()
  {
    if(widget.TimerState)
      {
        _stopWatchTimer.onResetTimer();
        widget.timerFunction(2);
      }else
        {
          _stopWatchTimer.onStartTimer();
          widget.timerFunction(1);
        }
  }

}
