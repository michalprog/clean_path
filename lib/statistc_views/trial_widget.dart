import 'package:flutter/material.dart';
import '../utils_files/statistic_utils.dart';
import '/data_types/record.dart';
import 'package:intl/intl.dart';

class TrialWidget extends StatelessWidget {
  final Record record;
  const TrialWidget({Key? key, required this.record}) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(
      seconds: StatisticUtils.getRecordDurationInSeconds(record),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Card(
        elevation: 3,
        color: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(StatisticUtils.getIconForAddiction(record.type)),
          title: Text(
            "Attempt number : ${record.id}",
            textAlign: TextAlign.center,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Text(
                record.isActive
                    ? "Start date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(record.activated)}"
                    : "Fail date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(record.desactivated!)}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 2),
              Text(
                "Duration: ${StatisticUtils.formatDurationFromSeconds(
                  StatisticUtils.getRecordDurationInSeconds(record),
                )}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          trailing: Container(
            width: 40,
            height: 60,
            decoration: BoxDecoration(
              color: record.isActive ? Colors.blue : Colors.red,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
