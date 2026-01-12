import 'package:flutter/material.dart';

import '../enums/enums.dart';
import '../widgets/daily_task_tile.dart';

class DailyTaskView extends StatelessWidget {
  const DailyTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("zadanie codzienne")),
      body: ListView(
        children: [
          DailyTaskTile(
            taskIcon: Icon(Icons.crop_square_sharp),
            type: DailyTaskType.hydration,
            taskTitle: 'hydration',
          ),
          DailyTaskTile(
            taskIcon: Icon(Icons.crop_square_sharp),
            type: DailyTaskType.learning,
            taskTitle: 'learning',
          ),
          DailyTaskTile(
            taskIcon: Icon(Icons.crop_square_sharp),
            type: DailyTaskType.meditation,
            taskTitle: 'meditation',
          ),
          DailyTaskTile(
            taskIcon: Icon(Icons.crop_square_sharp),
            type: DailyTaskType.workout,
            taskTitle: 'workout',
          ),
        ],
      ),
    );
  }
}
