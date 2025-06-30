import 'package:clean_path/statistc_views/trial_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/statistics_provider.dart';

class AllAttempsList extends StatelessWidget {
  const AllAttempsList({super.key});

  @override
  Widget build(BuildContext context) {
    final statisticsProvider = Provider.of<StatisticsProvider>(context);
    return FutureBuilder(
      future: statisticsProvider.provideMainData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Błąd: ${snapshot.error}"));
        } else {
          final records = statisticsProvider.allRecords;

          if (records.isEmpty) {
            return Center(child: Text("No Records"));
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return TrialWidget(record: record);
            },
          );
        }
      },
    );
  }
}
