import 'package:flutter/material.dart';
import '../utils_files/statistic_utils.dart';
import '/data_types/record.dart';

class TrialWidget extends StatelessWidget {
  final Record record;
  const TrialWidget({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
            "Attemp number : ${record.id}  ",
            textAlign: TextAlign.center,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Text(
                "fail date: ${record.desactivated}",
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
              color: record.isActive ?  Colors.blue : Colors.red,
              borderRadius: BorderRadius.circular(3), // lekko zaokrąglone rogi
            ),
          ),
        ),
      ),
    );
  }
}
