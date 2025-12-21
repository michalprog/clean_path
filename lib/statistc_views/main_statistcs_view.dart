import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/l10n/app_localizations.dart';
import '/widgets/flchart_widget.dart';
import '/widgets/statistic_state_tile.dart';
import '/utils_files/statistic_utils.dart';
import '/providers/statistics_provider.dart';
import '/widgets/Statistic_list_tile.dart';

class MainStatistcsView extends StatelessWidget {

  const MainStatistcsView({super.key});

  @override
  Widget build(BuildContext context) {

    final statisticsProvider = Provider.of<StatisticsProvider>(context);
    final l10n = AppLocalizations.of(context)!;
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
                mainText: l10n.totalAttempts,
                highlightedText: "${statisticsProvider.allRecords.length}",
              ),
              StatisticListTile(
                mainText: l10n.averageAttemptTime,
                highlightedText: StatisticUtils.formatDurationFromSeconds(
                  StatisticUtils.averageRecordDurationInSeconds(
                    statisticsProvider.allRecords,
                  ),
                ),
              ),
              StatisticStateTile(
                mainText: l10n.noFapStatus,
                typeState: StatisticUtils.isActiveRecord(
                  statisticsProvider.fapRecords,
                ),
              ),
              StatisticStateTile(
                mainText: l10n.noSmokingStatus,
                typeState: StatisticUtils.isActiveRecord(
                  statisticsProvider.papRecords,
                ),
              ),
              StatisticStateTile(
                mainText: l10n.noAlcoholStatus,
                typeState: StatisticUtils.isActiveRecord(
                  statisticsProvider.alcRecords,
                ),
              ),
              StatisticStateTile(
                mainText: l10n.noSweetStatus,
                typeState: StatisticUtils.isActiveRecord(
                  statisticsProvider.sweetRecords,
                ),
              ),
              const SizedBox(height: 10),
              FlchartWidget(
                records: statisticsProvider.allRecords,
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