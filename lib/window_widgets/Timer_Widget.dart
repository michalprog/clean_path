import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../providers/database_provider.dart';

class TimerWidget extends StatefulWidget {
  final Function (int option) timerFunction;
  final int startCounter;
  const TimerWidget({super.key, required this.timerFunction, required this.startCounter} );

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

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.greenAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
            builder: (context, snapshot) {
              final value = snapshot.data ?? widget.startCounter;
              return Text(
                _formatTime(value),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),

        SizedBox(height: 10),

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

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => startTimer(),
              child: Text("Start"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => resetTimer(),
              child: Text("Reset"),
            ),
          ],
        ),
      ],
    );
  }

  void startTimer() {
    _stopWatchTimer.onStartTimer();
    widget.timerFunction(1);
  }

  void resetTimer() {
    _stopWatchTimer.onResetTimer();
    widget.timerFunction(2);
  }
}

