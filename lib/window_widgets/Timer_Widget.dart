import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../providers/database_provider.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {

  final _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  static const int countdownStart = 1 * 86400000; // 1 dzień = 86 400 000 ms

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
              final value = snapshot.data ?? 0;
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

        // Countdown - mniejsza czcionka
        StreamBuilder<int>(
          stream: _stopWatchTimer.rawTime,
          builder: (context, snapshot) {
            final value = snapshot.data ?? 0;
            final countdownTime = (1 * 86400000) - value; // Odliczanie od 1 dnia

            return Text(
              "To next Achivment: ${_formatTime(countdownTime)}",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            );
          },
        ),

        SizedBox(height: 20),

        // Przyciski sterujące
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: ()=>_stopWatchTimer.onStartTimer(),
              child: Text("Start"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: ()=>_stopWatchTimer.onResetTimer(),
              child: Text("Reset"),
            ),
          ],
        ),
      ],
    );
  }
}
