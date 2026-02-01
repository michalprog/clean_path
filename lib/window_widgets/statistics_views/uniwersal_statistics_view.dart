import 'package:clean_path/data_types/record.dart';
import 'package:clean_path/widgets/statistics_widgets/flchart_widget.dart';
import 'package:clean_path/widgets/statistics_widgets/statistic_state_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/enums/enums.dart';
import '/l10n/app_localizations.dart';
import '/providers/statistics_provider.dart';
import '/utils_files/statistic_utils.dart';
import 'package:clean_path/widgets/statistics_widgets/statistic_list_tile.dart';

class UniwersalStatisticsView extends StatelessWidget {
  final AddictionTypes type;
  const UniwersalStatisticsView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final statisticsProvider = Provider.of<StatisticsProvider>(context);
    final l10n = AppLocalizations.of(context)!;
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
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return ListView(
            children: [
              StatisticListTile(
                mainText: l10n.totalNumberOfAttempts,
                highlightedText: "${getRecordsType().length}",
              ),
              StatisticListTile(
                mainText: l10n.averageAttemptTime,
                highlightedText: StatisticUtils.formatDurationFromSeconds(
                  StatisticUtils.averageRecordDurationInSeconds(
                    getRecordsType(),
                  ),
                ),
              ),
              StatisticListTile(
                mainText: l10n.longestAttemptTime,
                highlightedText: StatisticUtils.formatDurationFromSeconds(
                  StatisticUtils.longestRecordDurationInSeconds(
                    getRecordsType(),
                  ),
                ),
              ),
              StatisticStateTile(
                mainText: l10n.isAttemptActive,
                typeState: StatisticUtils.isActiveRecord(getRecordsType()),
              ),
              StatisticUtils.isActiveRecord(getRecordsType())
                  ? StatisticListTile(
                    mainText: l10n.currentDuration,
                    highlightedText: StatisticUtils.formatDurationFromSeconds(
                      StatisticUtils.getActiveRecordDuration(getRecordsType()),
                    ),
                  )
                  : SizedBox.shrink(),
              const SizedBox(height: 10),
              FlchartWidget(
                records: getRecordsType(),
                titleText: l10n.timesOfTrials,
              ),
              const SizedBox(height: 50),
            ],
          );
        }
      },
    );
  }
}
