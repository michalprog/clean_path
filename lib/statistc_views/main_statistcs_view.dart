import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/statistic_state_tile.dart';
import '/utils_files/statistic_utils.dart';
import '/providers/statistics_provider.dart';
import '/widgets/Statistic_list_tile.dart';

class MainStatistcsView extends StatelessWidget {

  const MainStatistcsView({super.key});

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
          return Container(child: ListView(
            children: [
             StatisticListTile(mainText: "liczba wszystkich prób", highlightedText:"${ statisticsProvider.allRecorods.length}"),
            StatisticListTile(
              mainText: "średni czas próby",
              highlightedText: StatisticUtils.formatDurationFromSeconds(
                  StatisticUtils.averageRecordDurationInSeconds(statisticsProvider.allRecords),

              ),

            ),
              StatisticStateTile(mainText: 'Fap Status', typeState: StatisticUtils.isActiveRecord(statisticsProvider.fapRecords) ),
              StatisticStateTile(mainText: 'Smoking Status', typeState: StatisticUtils.isActiveRecord(statisticsProvider.papRecords) ),
              StatisticStateTile(mainText: 'Alcohol Status', typeState: StatisticUtils.isActiveRecord(statisticsProvider.alcRecords) ),
              StatisticStateTile(mainText: 'Sweet Status', typeState: StatisticUtils.isActiveRecord(statisticsProvider.sweetRecords) ),
            ],



          ),);
        }
      },
    );


  }


}
