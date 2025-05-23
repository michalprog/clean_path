import 'package:flutter/material.dart';
import '../utils_files/statistic_utils.dart';
import '/data_types/record.dart';

class TrialWidget extends StatelessWidget {
  final Record record;
  const TrialWidget({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Gradient backgroundGradient = record.isActive
        ? LinearGradient(
      colors: [
        Colors.green.shade100,
        Colors.green.shade400,
        Colors.grey.shade200,
      ],
      stops: [0.0, 0.5, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )
        : LinearGradient(
      colors: [
        Colors.grey.shade300,
        Colors.grey.shade500,
        Colors.white,
      ],
      stops: [0.0, 0.5, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        elevation: 3,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            "#id: ${record.id}  type: ${record.type.name}",
            textAlign: TextAlign.center,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Text(
                "Start: ${record.activated}",
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
        ),
      ),
    );
  }
}
