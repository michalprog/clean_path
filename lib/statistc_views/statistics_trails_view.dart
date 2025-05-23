import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data_types/record.dart';
import '../providers/statistics_provider.dart';

class StatisticsTrailsView extends StatelessWidget {
  const StatisticsTrailsView({super.key});

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
            ],



          ),);
        }
      },
    );
  }
}
