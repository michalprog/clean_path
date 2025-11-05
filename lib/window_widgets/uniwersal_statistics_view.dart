import 'package:clean_path/data_types/record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/enums/enums.dart';
import '/providers/statistics_provider.dart';
import '/utils_files/statistic_utils.dart';
import '/widgets/Statistic_list_tile.dart';
import '/widgets/flchart_widget.dart';
import '/widgets/statistic_state_tile.dart';

class UniwersalStatisticsView extends StatelessWidget {
  final AddictionTypes type;
  const UniwersalStatisticsView({Key? key, required this.type})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statisticsProvider = Provider.of<StatisticsProvider>(context);
    List<Record> getRecordsType() {
      switch (type) {
        case AddictionTypes.fap:
          return statisticsProvider.fapRecords;
        case AddictionTypes.smoking:
          return statisticsProvider.papRecords;
        case AddictionTypes.alcochol:
          return statisticsProvider.alcRecords;
        case AddictionTypes.sweets:
          return statisticsProvider.sweetRecords;
      }
    }

    return FutureBuilder(
      future: statisticsProvider.provideMainData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Błąd: ${snapshot.error}"));
        } else {
          return Container(
            child: ListView(
              children: [
                StatisticListTile(
                  mainText: "Total number of attempts",
                  highlightedText: "${getRecordsType().length}",
                ),
                StatisticListTile(
                  mainText: "Average attempt time",
                  highlightedText: "${StatisticUtils.formatDurationFromSeconds(
                    StatisticUtils.averageRecordDurationInSeconds(getRecordsType()),)}",
                ),
                StatisticListTile(mainText: "Longest attempt time", highlightedText: "${StatisticUtils.formatDurationFromSeconds(
                  StatisticUtils.longestRecordDurationInSeconds(getRecordsType()),)}",),
                StatisticStateTile(mainText: "Is attempt active?", typeState: StatisticUtils.isActiveRecord(getRecordsType()), ),
                StatisticUtils.isActiveRecord(getRecordsType()) ? StatisticListTile(mainText: "Current duration", highlightedText: StatisticUtils.formatDurationFromSeconds(
                  StatisticUtils.getActiveRecordDuration(getRecordsType()),
                ),) : SizedBox.shrink(),
                const SizedBox(height: 10),
                FlchartWidget(records: getRecordsType(), titleText: 'times of trials',),
                const SizedBox(height: 50),],
            ),
          );
        }
      },
    );
  }
}
